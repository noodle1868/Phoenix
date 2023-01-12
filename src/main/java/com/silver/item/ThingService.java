package com.silver.item;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.Date;
import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.silver.member.MemberDTO;

@Service
public class ThingService {
	
	Logger logger = LoggerFactory.getLogger(getClass());
	
	private final ThingDAO dao;
		
	public ThingService(ThingDAO dao) {
		this.dao = dao;
	}

	public HashMap<String, Object> getThingList(int page) {
		/* 페이징 계산 */
		int offset = 10*(page-1);
		int totalCount = dao.totalCountThList();
		logger.info("게시글 총 개수 : "+totalCount);
		int totalPages = totalCount%10>0 ? (totalCount/10)+1 : (totalCount/10);//총 페이지 수 = 게시물 총 갯수 / 페이지당 보여줄 수 (나누기) 
		logger.info("총 페이지 수 : "+totalPages);
		
		logger.info("비품 목록을 가져옵니다.");
		HashMap<String, Object> result=new HashMap<String, Object>();
		ArrayList<ThingDTO> thingList = dao.getThingList(offset);
		result.put("list", thingList);
		result.put("total", totalPages);
		return result;
	}

	public HashMap<String, Object> getThingListSearch(HashMap<String, String> params) {
		logger.info("받아온 데이터 : {}", params);
		logger.info("비품 검색 기능 접근");
		int page = Integer.parseInt(params.get("page"));
		int offset = 10*(page-1);
		int totalCount = dao.totalCountThFilterList(params);
		logger.info("게시글 총 개수 : "+totalCount);
		int totalPages = totalCount%10>0 ? (totalCount/10)+1 : (totalCount/10);//총 페이지 수 = 게시물 총 갯수 / 페이지당 보여줄 수 (나누기)
		logger.info("총 페이지 수 : "+totalPages);
		
		ThingDTO dto = new ThingDTO();
		dto.setTh_name(params.get("thName"));
		dto.setTh_write(params.get("thWrite"));
		dto.setTh_spon(params.get("thSpon"));
		dto.setTh_part(params.get("thPart"));
		dto.setTh_state(params.get("thState"));
		dto.setOffset(offset);
		
		ArrayList<ThingDTO> thingList = dao.getThingListSearch(dto);
		
		HashMap<String, Object> result = new HashMap<String, Object>();
		result.put("list", thingList);
		result.put("total", totalPages);
		return result;
	}

	public HashMap<String, Object> getThingDetail(String thIdx) {
		ThingDTO dto = dao.getThingDetail(thIdx);
		logger.info("가져온 데이터 : {}", dto);
		ThingDTO photoDto = dao.photoView(thIdx);
		logger.info("사진데이터 : {}", photoDto);
		HashMap<String, Object> result = new HashMap<String, Object>();
		result.put("detail", dto);
		result.put("detailPhoto", photoDto);
		return result;
	}
	
	@Transactional
	public HashMap<String, Object> thingWrite(MultipartFile thPhoto, HashMap<String, String> params, HttpServletRequest request) {
		logger.info("받아온 요소 : {}", params);
		ThingDTO dto = new ThingDTO();
		Date thDate = Date.valueOf(params.get("thDate"));
		dto.setIt_idx(Integer.parseInt(params.get("thCateReal")));
		dto.setTh_name(params.get("thName"));
		dto.setTh_part(params.get("thPart"));
		dto.setTh_date(thDate);
		dto.setTh_model(params.get("thModel"));
		dto.setTh_money(Integer.parseInt(params.get("thMoney")));
		dto.setTh_spon(params.get("thSpon"));
		
		/* 등록자 세션 처리 */
		String thWrite = "로그인 안 하고 작성";
		
		HttpSession session=request.getSession();
		MemberDTO SessionDTO=(MemberDTO) session.getAttribute("loginId");
		logger.info("SessionDTO : "+SessionDTO);
		if(SessionDTO != null) {
			logger.info("세션이 존재합니다 세션에 저장된 이름 : "+SessionDTO.getMem_name());
			thWrite = SessionDTO.getMem_name();
		}
		dto.setTh_write(thWrite);
		logger.info("db에 작성될 등록자 이름 : "+dto.getTh_write());
		//---

		int row = dao.thingWrite(dto);
		int thIdx = dto.getTh_idx();
		logger.info("db table 영향받은 행의 개수 : "+row);
		logger.info("insert한 thIdx : "+thIdx);
		
		if(thPhoto != null){
			String oriFileName = thPhoto.getOriginalFilename();
			logger.info("첨부된 사진이 있습니다. 사진 명 : "+oriFileName);
			if(oriFileName != null && !oriFileName.equals("")) { //사진 있음
				String ext = oriFileName.substring(oriFileName.lastIndexOf("."));// 확장자 추출
				String newFileName = fileSave(thPhoto,ext);
				logger.info("서버에 저장될 파일 이름 : "+newFileName);
				if(!newFileName.equals("")) {
					dao.photoInsert(oriFileName, newFileName, thIdx);
				}
			}
		}
		
		HashMap<String, Object> result=new HashMap<String, Object>();
		result.put("thIdx", thIdx);
		return result;
	}
	
	/* 파일 저장 메서드 */
	/**
	 * 파일 객체와 확장자를 넣으면 파일 저장 후 저장된 파일명을 반환
	 * @param photo 파일 객체
	 * @param ext 확장자명
	 * @return 저장한 파일명
	 */
	private String fileSave(MultipartFile photo, String ext) {
		logger.info("파일 저장 기능 접근");
		// 1. 새 파일명 생성
		String newFileName = System.currentTimeMillis()+ext;
		logger.info("서버에 저장될 파일명이 생성되었습니다. 파일명 : "+newFileName);
		
		// 2. 저장
		try {
			byte[] bytes = photo.getBytes();
			Path path = Paths.get("C:/filephoto/"+newFileName);
			logger.info("저장될 파일 경로 : {}", path);
			Files.write(path, bytes);
			logger.info("파일 저장 완료");
		} catch (IOException e) {
			logger.info("파일 저장 실패! 저장될 파일 이름을 초기화합니다.");
			newFileName = "";
			e.toString();
		}
		
		// 3. 새 파일 명 반환
		return newFileName;
	}
	
	public boolean thingCheck(String thName) {
		String thingCheck = dao.thingCheck(thName);
		return thingCheck == null? false : true;
	}
	
	@Transactional
	public HashMap<String, Object> thingUpdate(MultipartFile thPhoto, HashMap<String, String> params,
			HttpServletRequest request) {
		logger.info("params : {}",params);
		/* 등록자 세션 처리 */
		String thWrite = "세션 못받음";
		
		HttpSession session=request.getSession();
		MemberDTO SessionDTO=(MemberDTO) session.getAttribute("loginId");
		logger.info("SessionDTO : "+SessionDTO);
		if(SessionDTO != null) {
			logger.info("세션이 존재합니다 세션에 저장된 이름 : "+SessionDTO.getMem_name());
			thWrite = SessionDTO.getMem_name();
		}
		params.put("thWrite", thWrite);
		logger.info("db에 작성될 등록자 이름 : "+params.get("thWrite"));
		
		dao.thingUpdate(params);
		
		if(thPhoto != null){
			String oriFileName = thPhoto.getOriginalFilename();
			logger.info("첨부된 사진이 있습니다. 사진 명 : "+oriFileName);
			if(oriFileName != null && !oriFileName.equals("")) { //사진 있음
				String ext = oriFileName.substring(oriFileName.lastIndexOf("."));// 확장자 추출
				String newFileName = fileSave(thPhoto,ext);
				logger.info("서버에 저장될 파일 이름 : "+newFileName);
				if(!newFileName.equals("")) {
					dao.photoUpdate(oriFileName, newFileName, params.get("thIdx"));
				}
			}
		}
		
		return getThingDetail(params.get("thIdx"));
	}
	
	public HashMap<String, Object> itemCateList() {
		HashMap<String, Object> result = new HashMap<String, Object>();
		ArrayList<ThingDTO> list = dao.itemCateList();
		result.put("list", list);
		
		return result;
	}
	
	public HashMap<String, Object> getItemSearch(String itName) {
		logger.info("카테고리 검색 서비스");
		ArrayList<ThingDTO> itemList = dao.getItemSearch(itName);
		HashMap<String, Object> result = new HashMap<String, Object>();
		logger.info("검색된 데이터 : {}", result);
		result.put("list", itemList);
		return result;
	}

	public HashMap<String, Object> itemCateResist(String cateName) {
		logger.info("저장할 cateName : "+cateName);
		HashMap<String, Object> result = new HashMap<String, Object>();
		int finish = 0;
		
		boolean cateCheck = cateNameCheck(cateName);
		logger.info("이름 중복검사 결과(false면 중복없음) : "+cateCheck);
		if(cateCheck == false) {
			finish = dao.itemCateResist(cateName);
		}
		logger.info("item insert - 영향받은 행 : "+finish);
		
		result.put("result", finish);
		return result;
	}
	
	public boolean cateNameCheck(String cateName) {
		String cateCheck = dao.cateNameCheck(cateName);
		return cateCheck == null? false : true;
	}

	public HashMap<String, Object> itemCateUpdate(int itIdx, String cateName) {
		logger.info("수정할 cateName : "+cateName);
		logger.info("들어갈 itIdx : "+cateName);
		
		int finish = 0;
		String cateCheck = dao.cateNameCheck(cateName); //이름 중복검사
		logger.info("이름 중복검사 결과(null이면 정상) : "+cateCheck);
		if(cateCheck == null) {
			finish = dao.itemCateUpdate(itIdx, cateName);
		}
		logger.info("item insert - 영향받은 행 : "+finish);
		
		HashMap<String, Object> result = new HashMap<String, Object>();
		result.put("result", finish);
		return result;
	}
	
	public HashMap<String, Object> getThingManageList(int page) {
		int offset = 10*(page-1);
		int totalCount = dao.totalCntThManage();
		logger.info("게시글 총 개수 : "+totalCount);
		int totalPages = totalCount%10>0 ? (totalCount/10)+1 : (totalCount/10);//총 페이지 수 = 게시물 총 갯수 / 페이지당 보여줄 수 (나누기) 
		logger.info("총 페이지 수 : "+totalPages);
		
		logger.info("비품 목록을 가져옵니다.");
		HashMap<String, Object> result=new HashMap<String, Object>();
		ArrayList<ThingDTO> thingManage = dao.getThingManageList(offset);
		result.put("list", thingManage);
		result.put("total", totalPages);
		return result;
	}

	public HashMap<String, Object> getThingManageSearch(HashMap<String, String> params) {
		logger.info("받아온 데이터 : {}", params);
		logger.info("비품 검색 기능 접근");
		int page = Integer.parseInt(params.get("page"));
		int offset = 10*(page-1);
		int totalCount = dao.totalCountManageSearch(params);
		logger.info("게시글 총 개수 : "+totalCount);
		int totalPages = totalCount%10>0 ? (totalCount/10)+1 : (totalCount/10);//총 페이지 수 = 게시물 총 갯수 / 페이지당 보여줄 수 (나누기)
		logger.info("총 페이지 수 : "+totalPages);
		
		ThingDTO dto = new ThingDTO();
		dto.setTh_name(params.get("thName"));
		dto.setTh_part(params.get("thPart"));
		dto.setTh_write(params.get("thWrite"));
		dto.setTh_model(params.get("thModel"));
		dto.setOffset(offset);
		
		ArrayList<ThingDTO> list = new ArrayList<ThingDTO>();
		list = dao.getThingManageSearch(dto);
		HashMap<String, Object> result = new HashMap<String, Object>();
		result.put("list", list);
		result.put("total", totalPages);
		
		return result;
	}
	
	public HashMap<String, Object> getThingHistoryList(int page) {
		int offset = 10*(page-1);
		int totalCount = dao.totalCntThHistory();
		logger.info("게시글 총 개수 : "+totalCount);
		int totalPages = totalCount%10>0 ? (totalCount/10)+1 : (totalCount/10);//총 페이지 수 = 게시물 총 갯수 / 페이지당 보여줄 수 (나누기) 
		logger.info("총 페이지 수 : "+totalPages);
		
		logger.info("비품 목록을 가져옵니다.");
		HashMap<String, Object> result=new HashMap<String, Object>();
		ArrayList<ThingDTO> thingHistory = dao.getThingHistoryList(offset);
		result.put("list", thingHistory);
		result.put("total", totalPages);
		return result;
	}

	public HashMap<String, Object> getThingHistorySearch(HashMap<String, String> params) {
		logger.info("받아온 데이터 : {}", params);
		logger.info("비품 검색 기능 접근");
		int page = Integer.parseInt(params.get("page"));
		int offset = 10*(page-1);
		int totalCount = dao.totalCountHistorySearch(params);
		logger.info("게시글 총 개수 : "+totalCount);
		int totalPages = totalCount%10>0 ? (totalCount/10)+1 : (totalCount/10);//총 페이지 수 = 게시물 총 갯수 / 페이지당 보여줄 수 (나누기)
		logger.info("총 페이지 수 : "+totalPages);
		
		ThingDTO dto = new ThingDTO();
		dto.setTh_name(params.get("thName"));
		dto.setTh_model(params.get("thModel"));
		dto.setHis_name(params.get("hisName"));
		dto.setTh_state(params.get("checkAllView"));
		dto.setOffset(offset);
		
		logger.info("검색된 비품 사용내역 목록을 가져옵니다.");
		ArrayList<ThingDTO> list = new ArrayList<ThingDTO>();
		list = dao.getThingHistorySearch(dto);
		HashMap<String, Object> result = new HashMap<String, Object>();
		result.put("list", list);
		result.put("total", totalPages);
		return result;
	}
	
	@Transactional
	public HashMap<String, Object> thingHistoryWrite(HashMap<String, String> params, HttpServletRequest request) {
		logger.info("받아온 데이터 : "+params);
		
		/* 등록자 세션 처리 */
		String hisWrite = "로그인 안 하고 작성";
		
		HttpSession session=request.getSession();
		MemberDTO SessionDTO=(MemberDTO) session.getAttribute("loginId");
		logger.info("SessionDTO : "+SessionDTO);
		if(SessionDTO != null) {
			logger.info("세션이 존재합니다 세션에 저장된 이름 : "+SessionDTO.getMem_name());
			hisWrite = SessionDTO.getMem_name();
		}
		
		params.put("hisWrite", hisWrite);
		
		int thIdx = dao.getThIdx(params.get("thName"));
		String parseThIdx = Integer.toString(thIdx);
		params.put("thIdx", parseThIdx);
		
		int finish = 0;
		finish = dao.thingHistoryWrite(params);
		
		if(finish==1) {
			logger.info("insert한 thIdx : "+thIdx);
			dao.writeThState(thIdx);
		}
		
		HashMap<String, Object> result = new HashMap<String, Object>();
		result.put("finish", finish);
		return result;
	}

}
