<%@page import="wt.org.WTUser"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<table class="button-table">
	<tr>
		<td class="left">
			<div class="header">
				<img src="/Windchill/extcore/images/header.png"> ECN
			</div>
		</td>
	</tr>
</table>
<div class="left">
	<div id="ecn_barChart"></div>
</div>
<div class="right">
	<div id="ecn_pieChart"></div>
</div>
<script src="https://code.highcharts.com/highcharts.js"></script>
<script type="text/javascript">

	//Create the bar chart
	Highcharts.chart('ecn_barChart', {
 		chart: {
     		type: 'column'
 		},
		title: {
		    align: 'left',
		    text: '변경사유'
		},
//  subtitle: {
//      align: 'left',
//      text: 'Click the columns to view versions. Source: <a href="http://statcounter.com" target="_blank">statcounter.com</a>'
//  },
		accessibility: {
		    announceNewData: {
		        enabled: true
		    }
		},
		xAxis: {
		    type: 'category'
		},
		yAxis: {
		    title: {
//          text: 'Total percent market share'
			}

		},
		legend: {
		    enabled: false
		},
		plotOptions: {
		    series: {
		        borderWidth: 0,
		        dataLabels: {
		            enabled: true,
		            format: '{point.y:.1f}%'
		        }
		    }
		},

		tooltip: {
		    headerFormat: '<span style="font-size:11px">{series.name}</span><br>',
		    pointFormat: '<span style="color:{point.color}">{point.name}</span>: <b>{point.y:.2f}%</b> of total<br/>'
		},

		series: [{
	        name: '변경사유',
	        colorByPoint: true,
	        data: [
	            {
	                name: '원가 절감',
	                y: 13.06,
	            },
	            {
	                name: '영업/마케팅',
	                y: 32.84,
	            },
	            {
	                name: '기능/성능 변경',
	                y: 11.18,
	            },
	            {
	                name: '공정 변경',
	                y: 38.12,
	            },
	            {
	                name: '자재 변경',
	                y: 42.33,
	            },
	            {
	                name: '허가/규제 변경',
	                y: 19.45,
	            },
	            {
	                name: '품질',
	                y: 15.45,
	            },
	            {
	                name: '라벨링',
	                y: 20.45,
	            },
	            {
	                name: '기타',
	                y: 29.582,
	            }
	        ]
	    }]
	});
	
	//Create the pie chart
	Highcharts.chart('ecn_pieChart', {
	    chart: {
	        plotBackgroundColor: null,
	        plotBorderWidth: null,
	        plotShadow: false,
	        type: 'pie'
	    },
	    title: {
	        text: '작성부서',
	        align: 'left'
	    },
	    tooltip: {
		    headerFormat: '<span style="font-size:11px">{series.name}</span><br>',
		    pointFormat: '<span style="color:{point.color}">{point.name}</span>: <b>{point.y:.2f}%</b><br/>'
		},
// 	    tooltip: {
// 	        pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
// 	    },
	    accessibility: {
	        point: {
	            valueSuffix: '%'
	        }
	    },
	    plotOptions: {
	        pie: {
	            allowPointSelect: true,
	            cursor: 'pointer',
	            dataLabels: {
	                enabled: true,
	                format: '<b>{point.name}</b>: {point.percentage:.1f} %'
	            }
	        }
	    },
	    series: [{
	        name: '작성부서',
	        colorByPoint: true,
	        data: [{
	            name: '연구소',
	            y: 38.47,
	            sliced: true,
	            selected: true
	        }, {
	            name: '제조',
	            y: 29.12
	        },  {
	            name: '생산',
	            y: 35.47
	        }, {
	            name: '기타',
	            y: 12.58
	        }]
	    }]
	});

</script>