<%@page import="com.e3ps.common.util.CommonUtil"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.ArrayList"%>
<%@page import="wt.session.SessionHelper"%>
<%@page import="wt.org.WTUser"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
boolean isWork = (boolean) request.getAttribute("isWork");
boolean isDoc = (boolean) request.getAttribute("isDoc");
boolean isPart = (boolean) request.getAttribute("isPart");
boolean isEpm = (boolean) request.getAttribute("isEpm");
boolean isChange = (boolean) request.getAttribute("isChange");
boolean isMold = (boolean) request.getAttribute("isMold");
boolean isRohs = (boolean) request.getAttribute("isRohs");
boolean isEtc = (boolean) request.getAttribute("isEtc");
%>
<nav class="navbar-default navbar-static-side" role="navigation">
	<div class="sidebar-collapse">
		<ul class="nav metismenu" id="side-menu">
			<li class="nav-header">
				<div class="dropdown profile-element">
					<a onclick="moveToPage(this, '/mainPage', '> 메인');">LUTRONIC</a>
					<!-- 					<a href="javascript:index();"> -->
					<%-- 						<span class="block m-t-xs font-bold"><%//=data.getName()%></span> --%>
					<!-- 						<span class="text-muted text-xs block"> -->
					<%-- 							<font color="white"><%//=data.getDepartment_name()%>-<%//=data.getDuty() != null ? data.getDuty() : "지정안됨"%></font> --%>
					<!-- 						</span> -->
					<!-- 					</a> -->
				</div>
			</li>
			
			<%
			%>
			<li>
				<a href="#">
					<i class="fa fa-magic"></i>
					<span class="nav-label">나의업무</span>
					<span class="fa arrow"></span>
				</a>
				<ul class="nav nav-second-level collapse">
					<li>
						<a onclick="moveToPage(this, '/groupware/listNotice', '> 나의업무 > 공지사항');">공지사항</a>
					</li>
					<li>
						<a onclick="moveToPage(this, '/groupware/workItem', '> 나의업무 > 작업함');">
							작업함
							<span class="label label-info float-right">
								<%
								//=count.get("check")
								%>
							</span>
						</a>
					</li>
					<li>
						<a onclick="moveToPage(this, '/groupware/listItem?state=ing', '> 나의업무 > 진행함');">
							진행함
							<span class="label label-info float-right">
								<%
								//=count.get("ing")
								%>
							</span>
						</a>
					</li>
					<li>
						<a onclick="moveToPage(this, '/groupware/listItem?state=complete', '> 나의업무 > 완료함');">
							완료함
							<span class="label label-info float-right">
								<%
								//=count.get("complete")
								%>
							</span>
						</a>
					</li>
					<li>
						<a onclick="moveToPage(this, '/groupware/listItem?state=receive', '> 나의업무 > 수신함');">
							수신함
							<span class="label label-info float-right">
								<%
								//=count.get("receive")
								%>
							</span>
						</a>
					</li>
					<li>
						<a onclick="moveToPage(this, '/asmApproval/listAsm', '> 나의업무 > 일괄결재 검색');">일괄결재 검색</a>
					</li>
					<li>
						<a onclick="moveToPage(this, '/org/organization', '> 나의업무 > 조직도');">조직도</a>
					</li>
					<li>
						<a onclick="moveToPage(this, '/groupware/password', '> 나의업무 > 비밀번호변경');">비밀번호 변경</a>
					</li>
					<li>
						<a onclick="moveToPage(this, '/groupware/manage', '> 나의업무 > 관리자메뉴');">관리자 메뉴</a>
					</li>
				</ul>
			</li>
			<li>
				<a href="#">
					<i class="fa fa-pie-chart"></i>
					<span class="nav-label">문서관리</span>
					<span class="fa arrow"></span>
				</a>
				<ul class="nav nav-second-level collapse">
					<li>
						<a onclick="moveToPage(this, '/doc/list', '> 문서관리 > 문서 검색');">문서 검색</a>
					</li>
					<li>
						<a onclick="moveToPage(this, '/doc/create', '> 문서관리 > 문서 등록');">문서 등록</a>
					</li>
					<li>
						<a onclick="moveToPage(this, '/doc/batch', '> 문서관리 > 문서 일괄등록');">문서 일괄등록</a>
					</li>
					<li>
						<a onclick="moveToPage(this, '/doc/register', '> 문서관리 > 문서 일괄결재');">문서 일괄결재</a>
					</li>
					<li>
						<a onclick="moveToPage(this, '/doc/template-list', '> 문서관리 > 문서 템플릿 검색');">문서 템플릿 검색</a>
					</li>
					<li>
						<a onclick="moveToPage(this, '/doc/template-create', '> 문서관리 > 문서 템플릿 등록');">문서 템플릿 등록</a>
					</li>
				</ul>
			</li>
			<li>
				<a href="#">
					<i class="fa fa-desktop"></i>
					<span class="nav-label">품목관리</span>
					<span class="fa arrow"></span>
				</a>
				<ul class="nav nav-second-level collapse">
					<li>
						<a onclick="moveToPage(this, '/part/list', '> 품목관리 > 품목 검색');">품목 검색</a>
					</li>
					<li>
						<a onclick="moveToPage(this, '/part/create', '> 품목관리 > 품목 등록');">품목 등록</a>
					</li>
					<li>
						<a onclick="moveToPage(this, '/part/batch', '> 품목관리 > 품목 일괄등록');">품목 일괄등록</a>
					</li>
					<li>
						<a onclick="moveToPage(this, '/part/bom', '> 품목관리 > BOM EDITOR');">BOM EDITOR</a>
					</li>
				</ul>
			</li>
			<li>
				<a href="#">
					<i class="fa fa-edit"></i>
					<span class="nav-label">도면 관리</span>
					<span class="fa arrow"></span>
				</a>
				<ul class="nav nav-second-level collapse">
					<li>
						<a onclick="moveToPage(this, '/drawing/list', '> 도면 관리 > 도면 검색');">도면 검색</a>
					</li>
					<li>
						<a onclick="moveToPage(this, '/drawing/create', '> 도면 관리 > 도면 등록');">도면 등록</a>
					</li>
					<li>
						<a onclick="moveToPage(this, '/drawing/batch', '> 도면 관리 >주 도면 일괄등록');">주 도면 일괄등록</a>
					</li>
				</ul>
			</li>
			<li>
				<a href="#">
					<i class="fa fa-files-o"></i>
					<span class="nav-label">설계변경</span>
					<span class="fa arrow"></span>
				</a>
				<ul class="nav nav-second-level collapse">
					<li>
						<a onclick="moveToPage(this, '/changeECO/listEO', '> 설계변경 >EO 검색');">EO</a>
					</li>
					<li>
						<a onclick="moveToPage(this, '/changeECR/list?eoType=CR', '> 설계변경 > CR 검색');">CR</a>
					</li>
					<li>
						<a onclick="moveToPage(this, '/changeECR/list?eoType=ECPR', '> 설계변경 > ECPR 검색');">ECPR</a>
					</li>
					<li>
						<a onclick="moveToPage(this, '/changeECO/list', '> 설계변경 > ECO 검색');">ECO</a>
					</li>
					<li>
						<a onclick="moveToPage(this, '/changeECN/list', '> 설계변경 > ECN 검색');">ECN</a>
					</li>
					<li>
						<a onclick="moveToPage(this, '/erp/send-listPARTERP', '> 관리자 >PART 전송 현황');">PART 전송 현황</a>
					</li>
					<li>
						<a onclick="moveToPage(this, '/erp/send-listECOERP', '> 관리자 >EO&ECO 전송 현황');">EO&ECO 전송 현황</a>
					</li>
					<li>
						<a onclick="moveToPage(this, '/erp/send-listBOMERP', '> 관리자 >BOM 전송 현황');">BOM 전송 현황</a>
					</li>
				</ul>
			</li>
			<li>
				<a href="#">
					<i class="fa fa-sitemap"></i>
					<span class="nav-label">RoHS</span>
					<span class="fa arrow"></span>
				</a>
				<ul class="nav nav-second-level collapse">
					<li>
						<a onclick="moveToPage(this, '/rohs/list', '> RoHS > 물질 검색');">물질 검색</a>
					</li>
					<li>
						<a onclick="moveToPage(this, '/rohs/create', '> RoHS > 물질 등록');">물질 등록</a>
					</li>
					<li>
						<a onclick="moveToPage(this, '/rohs/listRohsFile', '> RoHS > 파일 검색');">파일 검색</a>
					</li>
					<li>
						<a onclick="moveToPage(this, '/rohs/listAUIRoHSPart', '> RoHS > 부품 현황');">부품 현황</a>
					</li>
					<li>
						<a onclick="moveToPage(this, '/rohs/listRoHSProduct', '> RoHS > 제품 현황');">제품 현황</a>
					</li>
					<li>
						<a onclick="moveToPage(this, '/rohs/all', '> RoHS > 물질 일괄결재');">물질 일괄결재</a>
					</li>
					<li>
						<a onclick="moveToPage(this, '/rohs/batch', '> RoHS > 물질 일괄등록');">물질 일괄등록</a>
					</li>
					<li>
						<a onclick="moveToPage(this, '/rohs/link', '> RoHS > 물질 일괄링크');">물질 일괄링크</a>
					</li>
				</ul>
			</li>

			<!-- <li>
				<a href="#">
					<i class="fa fa-files-o"></i>
					<span class="nav-label">BOM 관리</span>
					<span class="fa arrow"></span>
				</a>
				<ul class="nav nav-second-level collapse">
					<li>
						<a onclick="moveToPage(this, '/partlist/list', '> BOM 관리 > 수배표 조회');">수배표 조회</a>
					</li>
					<li>
						<a onclick="moveToPage(this, '/tbom/list', '> BOM 관리 > T-BOM 조회');">T-BOM 조회</a>
					</li>
				</ul>
			</li>
			<li>
				<a href="#">
					<i class="fa fa-sitemap"></i>
					<span class="nav-label">한국 생산</span>
					<span class="fa arrow"></span>
				</a>
				<ul class="nav nav-second-level collapse">
					<li>
						<a onclick="moveToPage(this, '/korea/list', '> 한국 생산 > 한국 생산');">한국 생산</a>
					</li>
					<li>
						<a onclick="moveToPage(this, '/configSheet/list', '> 한국 생산 > CONFIG SHEET 조회');">CONFIG SHEET 조회</a>
					</li>
					<li>
						<a onclick="moveToPage(this, '/cip/list', '> 한국 생산 > CIP 조회');">CIP 조회</a>
					</li>
					<li>
						<a onclick="moveToPage(this, '/history/list', '> 한국 생산 > 이력 관리 조회');">이력 관리 조회</a>
					</li>
				</ul>
			</li> -->
			<li>
				<a href="#">
					<i class="fa fa-files-o"></i>
					<span class="nav-label">금형관리</span>
					<span class="fa arrow"></span>
				</a>
				<ul class="nav nav-second-level collapse">
					<li>
						<a onclick="moveToPage(this, '/mold/list', '> 금형관리 > 금형 검색');">금형 검색</a>
					</li>
					<li>
						<a onclick="moveToPage(this, '/mold/create', '> 금형관리 > 금형 등록');">금형 등록</a>
					</li>
					<li>
						<a onclick="moveToPage(this, '/mold/all', '> 금형관리 > 금형 일괄결재');">금형 일괄결재</a>
					</li>
				</ul>
			</li>
			<li>
				<a href="#">
					<i class="fa fa-files-o"></i>
					<span class="nav-label">기타문서관리</span>
					<span class="fa arrow"></span>
				</a>
				<ul class="nav nav-second-level collapse">
<!-- 					<li> -->
<!-- 						<a onclick="moveToPage(this, '/mold/ap-list', '> 승인원 > 승인원 검색');">승인원 검색</a> -->
<!-- 					</li> -->
<!-- 					<li> -->
<!-- 						<a onclick="moveToPage(this, '/mold/ap-create', '> 승인원 > 승인원 등록');">승인원 등록</a> -->
<!-- 					</li> -->
<!-- 					<li> -->
<!-- 						<a onclick="moveToPage(this, '/mold/ap-all', '> 승인원 > 승인원 결재');">승인원 결재</a> -->
<!-- 					</li> -->
						<li>
							<a onclick="moveToPage(this, '/doc/list', '> 생산본부 문서 > 생산본부 문서검색);">생산본부 문서검색</a>
						</li>
						<li>
							<a onclick="moveToPage(this, '/doc/list', '> 병리연구 문서 > 병리연구 문서검색);">병리연구 문서검색</a>
						</li>
						<li>
							<a onclick="moveToPage(this, '/doc/list', '> 임상개발 문서 > 임상개발 문서검색);">임상개발 문서검색</a>
						</li>
						<li>
							<a onclick="moveToPage(this, '/doc/list', '> RA팀 문서 > RA팀 문서검색);">RA팀 문서검색</a>
						</li>
						<li>
							<a onclick="moveToPage(this, '/doc/list', '> 화장품 문서 > 화장품 문서검색);">화장품 문서검색</a>
						</li>
				</ul>
			</li>
			<%
			if (CommonUtil.isAdmin()) {
			%>
			<li>
				<a href="css_animation.html">
					<i class="fa fa-magic"></i>
					<span class="nav-label">관리자</span>
					<span class="fa arrow"></span>
				</a>
				<ul class="nav nav-second-level collapse">
					<li>
						<a onclick="moveToPage(this, '/admin/numberCodeList', '> 관리자 > 코드체계관리');">코드체계관리</a>
					</li>
					<li>
						<a onclick="moveToPage(this, '/admin/changeActivityList', '> 관리자 > 설계변경관리');">설계변경관리</a>
					</li>
					<li>
						<a onclick="moveToPage(this, '/admin/adminMail', '> 관리자 > 외부메일관리');">외부메일관리</a>
					</li>
					<li>
						<a onclick="moveToPage(this, '/admin/loginHistory', '> 관리자 > 접속이력관리');">접속이력관리</a>
					</li>
					<li>
						<a onclick="moveToPage(this, '/admin/downLoadHistory', '> 관리자 > 다운로드 이력관리');">다운로드 이력관리</a>
					</li>
					<li>
						<a onclick="moveToPage(this, '/admin/adminPackage', '> 관리자 > 등록양식관리');">등록양식관리</a>
					</li>
					<li>
						<a onclick="popup('/Windchill', 1600, 800);">Windchill</a>
					</li>
					<li>
						<a onclick="moveToPage(this, '/admin/ecoTemplate', '> 관리자 > 설계변경 문서 템플릿');">설계변경 문서 템플릿</a>
					</li>
				</ul>
			</li>
			<%
			}
			%>
			<%
			if (CommonUtil.isAdmin()) {
			%>
			<li>
				<a href="css_animation.html">
					<i class="fa fa-magic"></i>
					<span class="nav-label">배포관리</span>
					<span class="fa arrow"></span>
				</a>
				<ul class="nav nav-second-level collapse">
					<li>
						<a href="#">
							<i class="fa fa-magic"></i>
							<span class="nav-label">나의 업무</span>
							<span class="fa arrow"></span>
						</a>
						<ul class="nav nav-second-level collapse">
							<li>
								<a onclick="moveToPage(this, '/groupware/listItem?state=check', '> 나의 업무 > 검토함');">
									검토함
									<span class="label label-info float-right">
										<%
										//=count.get("check")
										%>
									</span>
								</a>
							</li>
							<li>
								<a onclick="moveToPage(this, '/groupware/listItem?state=approval', '> 나의 업무 > 결재함');">
									결재함
									<span class="label label-info float-right">
										<%
										//=count.get("approval")
										%>
									</span>
								</a>
							</li>
							<li>
								<a onclick="moveToPage(this, '/groupware/listItem?state=receive', '> 나의 업무 > 수신함');">
									수신함
									<span class="label label-info float-right">
										<%
										//=count.get("receive")
										%>
									</span>
								</a>
							</li>
							<li>
								<a onclick="moveToPage(this, '/groupware/listCompanyTree', '> 나의 업무 > 조직도');">조직도</a>
							</li>
							<li>
								<a onclick="moveToPage(this, '/groupware/changePassword', '> 나의 업무 > 비밀번호변경');">비밀번호 변경</a>
							</li>
						</ul>
					</li>
					<li>
						<a href="#">
							<i class="fa fa-desktop"></i>
							<span class="nav-label">품목검색</span>
							<span class="fa arrow"></span>
						</a>
						<ul class="nav nav-second-level collapse">
							<li>
								<a onclick="moveToPage(this, '/part/list', '> 품목관리 > 품목 검색');">품목 검색</a>
							</li>
							<li>
								<a onclick="moveToPage(this, '/distribute/listProduction', '> 품목관리 > 완제품 검색');">완제품 검색</a>
							</li>
						</ul>
					</li>
					<li>
						<a href="#">
							<i class="fa fa-files-o"></i>
							<span class="nav-label">설계변경</span>
							<span class="fa arrow"></span>
						</a>
						<ul class="nav nav-second-level collapse">
							<li>
								<a onclick="moveToPage(this, '/changeECO/list', '> 설계변경 > ECO 검색');">ECO 검색</a>
							</li>
							<li>
								<a onclick="moveToPage(this, '/changeECO/listEO', '> 설계변경 >EO 검색');">EO 검색</a>
							</li>
						</ul>
					</li>
					<li>
						<a href="#" onclick="moveToPage(this, '/doc/list', '> 문서 관리 > 문서 검색');">
							<i class="fa fa-pie-chart"></i>
							<span class="nav-label">문서 검색</span>
						</a>
					</li>
					<li>
						<a href="#" onclick="moveToPage(this, '/mold/list', '> 금형관리 > 금형 검색');">
							<i class="fa fa-files-o"></i>
							<span class="nav-label">금형 검색</span>
						</a>
					</li>
				</ul>
			</li>
			<%
			}
			%>
			<!-- <li>
				<a href="#">
					<i class="fa fa-sitemap"></i>
					<span class="nav-label">시스템 로그</span>
					<span class="fa arrow"></span>
				</a>
				<ul class="nav nav-second-level collapse">
					<li>
						<a onclick="moveToPage(this, '/erp/list', '> ERP 로그 > ERP 로그');">ERP 로그</a>
					</li>
					<li>
						<a onclick="moveToPage(this, '/system/list', '> 에러 로그 > 에러 로그');">에러 로그</a>
					</li>
				</ul>
			</li>
			<li>
				<a href="css_animation.html">
					<i class="fa fa-magic"></i>
					<span class="nav-label">관리자</span>
					<span class="fa arrow"></span>
				</a>
				<ul class="nav nav-second-level collapse">
					<li>
						<a onclick="moveToPage(this, '/commonCode/list', '> 관리자 > 코드 관리');">코드 관리</a>
					</li>
					<li>
						<a onclick="moveToPage(this, '/specCode/list', '> 관리자 > 이력 관리 컬럼');">이력 관리 컬럼</a>
					</li>
					<li>
						<a onclick="moveToPage(this, '/configSheetCode/list', '> 관리자 > CONFIG SHEET 카테고리');">CONFIG SHEET 카테고리</a>
					</li>
					<li>
						<a onclick="moveToPage(this, '/numberRuleCode/list', '> 관리자 > KEK 도번 관리');">KEK 도번 관리</a>
					</li>
					<li>
						<a onclick="moveToPage(this, '/meeting/template', '> 관리자 > 회의록 템플릿');">회의록 템플릿</a>
					</li>
				</ul>
			</li> -->
		</ul>
	</div>
</nav>
