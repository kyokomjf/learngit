<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<base href="<%=basePath%>">

<title>用户数据查询界面</title>
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
<meta http-equiv="description" content="SearchUsers">
<script type="text/javascript" src="js/jquery.js"></script>
<script type="text/javascript">
	window.onload=function() 
	{
	   //$("#tdiv").hide();
	}
	 
//排序 tableId: 表的id,iCol:第几列 ；dataType：iCol对应的列显示数据的数据类型
    function sortAble(th, tableId, iCol, dataType) {

        var ascChar = "▲";
        var descChar = "▼";

        var table = document.getElementById(tableId);

        //排序标题加背景色
        for (var t = 0; t < table.tHead.rows[0].cells.length; t++) {
            var th = $(table.tHead.rows[0].cells[t]);
            var thText = th.html().replace(ascChar, "").replace(descChar, "");
            if (t == iCol) {
                th.css("background-color", "#ccc");
            }
            else {
                th.css("background-color", "#fff");
                th.html(thText);
            }

        }

        var tbody = table.tBodies[0];
        var colRows = tbody.rows;
        var aTrs = new Array;

        //将得到的行放入数组，备用
        for (var i = 0; i < colRows.length; i++) {
             
                aTrs.push(colRows[i]);
            //}
        }


        //判断上一次排列的列和现在需要排列的是否同一个。
        var thCol = $(table.tHead.rows[0].cells[iCol]);
        if (table.sortCol == iCol) {
            aTrs.reverse();
        } else {
            //如果不是同一列，使用数组的sort方法，传进排序函数
            aTrs.sort(compareEle(iCol, dataType));
        }

        var oFragment = document.createDocumentFragment();
        for (var i = 0; i < aTrs.length; i++) {
            oFragment.appendChild(aTrs[i]);
        }
        tbody.appendChild(oFragment);

        //记录最后一次排序的列索引
        table.sortCol = iCol;

        //给排序标题加“升序、降序” 小图标显示
        var th = $(table.tHead.rows[0].cells[iCol]);
        if (th.html().indexOf(ascChar) == -1 && th.html().indexOf(descChar) == -1) {
            th.html(th.html() + ascChar);
        }
        else if (th.html().indexOf(ascChar) != -1) {
            th.html(th.html().replace(ascChar, descChar));
        }
        else if (th.html().indexOf(descChar) != -1) {
            th.html(th.html().replace(descChar, ascChar));
        }

        //重新整理分组
        var subRows = $("#" + tableId + " tr[parent]");
        for (var t = subRows.length - 1; t >= 0 ; t--) {
            var parent = $("#" + tableId + " tr[group='" + $(subRows[t]).attr("parent") + "']");
            parent.after($(subRows[t]));
        }
    }

    //将列的类型转化成相应的可以排列的数据类型
    function convert(sValue, dataType) {
        switch (dataType) {
            case "int":
                return parseInt(sValue, 10);
            case "float":
                return parseFloat(sValue);
            case "date":
                return new Date(Date.parse(sValue));
            case "string":
            default:
                return sValue.toString();
        }
    }

    //排序函数，iCol表示列索引，dataType表示该列的数据类型
    function compareEle(iCol, dataType) {
        return function (oTR1, oTR2) {

            var vValue1 = convert(removeHtmlTag($(oTR1.cells[iCol]).html()), dataType);
            var vValue2 = convert(removeHtmlTag($(oTR2.cells[iCol]).html()), dataType);
            if (vValue1 < vValue2) {
                return -1;
            }
            else {
                return 1;
            }

        };
    }

    //去掉html标签
    function removeHtmlTag(html) {
        return html.replace(/<[^>]+>/g, "");
    }

</script>
</head>
<body >
	<table border="0" align="left"  cellspacing="0">
	 <tr>
 	 	<td align="left">显示排序: <select id="sortid" size="1" name="su_sort">
 	 	<option value="">默认</option>
 	 	<option value="getId_asc">ID(asc)</option>
 	 	<option value="getId_desc">ID(desc)</option>
 	 	<option value="getLoginname_asc">登录名(asc)</option>
 	 	<option value="getLoginname_desc">登录名(desc)</option>
 	 	</select></td>
 	 	 
 	 	<td><input type="button" value="查询" onclick="query()" /> </td>
	 </tr>
	</table>
    <br> 
    <br> 
	<table id="tid" align="left" width="400" border="1" cellspacing="0">
		<thead>
			<tr>
				<td  onclick="sortAble(this,'tid', 0,'int')">ID </td>
				<td  onclick="sortAble(this,'tid', 1,'string')">登录名 </td>
				<td>密码</td>
				<td>姓名</td>
			</tr>
		</thead>
		
		<tbody id="t_user"></tbody>
	</table>
	 <br> 
    <br>
	<table border="0" align="center" width="100%" cellpadding="0" cellspacing="0">
	  <tr> 
	    <td bgcolor="#CCCCCC">帮助信息：</td>
	  </tr>
	  <tr>
	    <td bgcolor="#CCCCCC">&nbsp;&nbsp;&nbsp;&nbsp;点击【ID】或【登录名】标题，可以分别进行排序
	   
	    </td>
	  </tr>
	  <tr>
	    <td width="100%" height="3" bgcolor="#408080"></td>
	  </tr>
	</table> 
 </body>
 <script type="text/javascript">
	function query() {
	   //$("#tdiv").show();
		$.ajax({
			type : "POST",
			url : "SearchUser",
			dataType:"json",
			data:"sort="+$("#sortid").val(),
			success : function(data) {
				$("#t_user").empty();
				//var d = eval('(' + data + ')');
				showData(data);
			}
		});
	}
	
	function showData(d) {
		for (var i = 0; i < d.length; i++) {
			var html = "<tr><td>" + d[i].id + "</td><td>" + d[i].loginname + "</td><td>" + d[i].password + "</td><td>" + d[i].name
				+ "</td></tr>";
			$("#t_user").append(html);
		}
	}
</script>
</html>
