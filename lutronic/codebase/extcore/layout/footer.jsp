<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!-- 다국어 작업 샘플... 추후 다른업체 필요할시 다국어 지원 -->
<div class="footer fixed">
	<div style="display: flex; justify-content: space-between; align-items: center;">
		<p style="margin: 0;">LUTRONIC PDM SYSTEM &copy; 2022-2023</p>
		<img id="scrollToTopIcon" style="cursor: pointer;" src="/Windchill/extcore/images/up_arrow.gif">
	</div>
</div>
<script>
	const f = document.getElementById('content');
	const fd = f.contentDocument || f.contentWindow.document;
	function scrollToTop() {
		fd.documentElement.scrollTop = 0;
		fd.body.scrollTop = 0;
	}
	document.getElementById("scrollToTopIcon").addEventListener("click", scrollToTop);
</script>
