<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<html>
<head>
	<base href="<%=basePath%>">
<meta charset="UTF-8">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet"/>
<link rel="stylesheet" type="text/css"
	  href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css">
<link rel="stylesheet" type="text/css" href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css">

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript"
		src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
<script type="text/javascript" src="jquery/bs_pagination-master/localization/en.js"></script>

<script type="text/javascript">

	$(function(){
		// 线索页面加载完成后，查询所有数据第一页以及所有数据的总条数，默认每页显示10条数据
		queryClueByConditionForPage(1, 10);

		//给"创建"按钮添加单击事件
		$("#createClueBtn").click(function () {
			//初始化工作
			$("#createClueForm")[0].reset();
			//弹出模态窗口
			$("#createClueModal").modal("show");
		});

		//给"保存"按钮添加单击事件
		$("#saveCreateClueBtn").click(function () {
			//收集参数
			var fullname       =$.trim($("#create-fullname").val());
			var appellation    =$("#create-appellation").val();
			var owner          =$("#create-owner").val();
			var company        =$.trim($("#create-company").val());
			var job            =$.trim($("#create-job").val());
			var email          =$.trim($("#create-email").val());
			var phone          =$.trim($("#create-phone").val());
			var website        =$.trim($("#create-website").val());
			var mphone         =$.trim($("#create-mphone").val());
			var state          =$("#create-state").val();
			var source         =$("#create-source").val();
			var description    =$.trim($("#create-description").val());
			var contactSummary =$.trim($("#create-contactSummary").val());
			var nextContactTime=$.trim($("#create-nextContactTime").val());
			var address        =$.trim($("#create-address").val());
			//表单验证
			//带*非空
			if (company == "") {
				alert("公司不能为空");
				return;
			}
			if (fullname == "") {
				alert("姓名不能为空");
				return;
			}
			//正则表达式验证
			if (email != "") { // 如果邮箱非空开始验证
				var emailRegExp = /^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/; // 邮件验证正则表达式
				if (!emailRegExp.test(email)) {
					alert("邮箱格式错误");
					return;
				}
			}
			if (phone != "") {
				var phoneRegExp = /0\d{2,3}-\d{7,8}/; // 国内座机电话号码验证："XXX-XXXXXXX"
				if (!phoneRegExp.test(phone)) {
					alert("座机号码格式错误");
					return;
				}
			}
			if (website != "") {
				var websiteRegExp = /^(?:(http|https|ftp):\/\/)?((?:[\w-]+\.)+[a-z0-9]+)((?:\/[^/?#]*)+)?(\?[^#]+)?(#.+)?$/i;
				if (!websiteRegExp.test(website)) {
					alert("网站格式错误");
					return;
				}
			}
			if (mphone != "") {
				var mphoneRegExp = /^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0|1|2|3|5|6|7|8|9])\d{8}$/;
				if (!mphoneRegExp.test(mphone)) {
					alert("手机号码格式错误");
					return;
				}
			}
			//发送请求
			$.ajax({
				url:'workbench/clue/saveCreateClue.do',
				data:{
					fullname       :fullname       ,
					appellation    :appellation    ,
					owner          :owner          ,
					company        :company        ,
					job            :job            ,
					email          :email          ,
					phone          :phone          ,
					website        :website        ,
					mphone         :mphone         ,
					state          :state          ,
					source         :source         ,
					description    :description    ,
					contactSummary :contactSummary ,
					nextContactTime:nextContactTime,
					address        :address
				},
				type:'post',
				dataType:'json',
				success:function (data) {
					if(data.code=="1"){
						//关闭模态窗口
						$("#createClueModal").modal("hide");
						//刷新线索列表，显示第一页数据，保持每页显示条数不变(作业)

					}else{
						//提示信息
						alert(data.message);
						//模态窗口不关闭
						$("#createClueModal").modal("show");
					}
				}
			});
		});

	});
	/**
	 * 分页查询函数功能：封装参数并发送请求
	 * @param pageNo 起始页码
	 * @param pageSize 单页显示数据条数
	 */
	function queryClueByConditionForPage(pageNo, pageSize) {
		// 收集线索前端界面的相关参数（条件查询的一些信息，如果不需要条件查询，就默认null）
		var fullname = $("#query-name").val();
		var company = $("#query-company").val();
		var phone = $("#query-phone").val();
		var source = $("#query-source option:selected").text(); // 获取下拉框选中的线索来源
		var owner = $("#query-owner").val();
		var mphone = $("#query-mphone").val();
		var state = $("#query-state option:selected").text(); // 获取下拉框选中的线索状态
		// 前端向后端发送请求
		$.ajax({
			url: 'workbench/clue/queryClueByConditionForPage.do',
			data: {
				fullname: fullname,
				company: company,
				phone: phone,
				source: source,
				owner: owner,
				mphone: mphone,
				state: state,
				pageNo: pageNo,
				pageSize: pageSize
			},
			type: 'post',
			dataType: 'json',
			success: function (data) {
				// 显示所有线索，遍历clueList，拼接所有行
				var htmlString = "";
				$.each(data.clueList, function (index, obj) {
					// checkbox中value存放了线索的id属性，用于删除和修改的调用
					htmlString += "<tr class=\"active\">";
					htmlString += "<td><input type=\"checkbox\" value=\"" + obj.id + "\"/></td>";
					htmlString += "<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='workbench/clue/detailClue.do?id=" + obj.id + "'\">" + obj.fullname + "" + obj.appellation + "</a></td>";
					htmlString += "<td>" + obj.company + "</td>";
					htmlString += "<td>" + obj.phone + "</td>";
					htmlString += "<td>" + obj.mphone + "</td>";
					htmlString += "<td>" + obj.source + "</td>";
					htmlString += "<td>" + obj.owner + "</td>";
					htmlString += "<td>" + obj.state + "</td>";
					htmlString += "</tr>";
				});
				$("#tBody").html(htmlString); // 写入页面
				$("#checkAll").prop("checked", false); // 换页时将全选按钮取消选中
				//计算总页数
				var totalPages = 1;
				if (data.totalRows % pageSize == 0) { // 总数据刚好可以整除页面
					totalPages = data.totalRows / pageSize;
				} else {
					totalPages = parseInt(data.totalRows / pageSize) + 1; // 页数不能是小数，将小数转换为整数
				}

				//对容器调用bs_pagination工具函数，显示翻页信息
				$("#page-master").bs_pagination({
					currentPage: pageNo, // 当前页号,相当于pageNo
					rowsPerPage: pageSize, // 每页显示条数,相当于pageSize
					totalRows: data.totalRows, // 总条数
					totalPages: totalPages,  // 总页数,必填参数.
					visiblePageLinks: 5, // 最多可以显示的卡片数
					showGoToPage: true, // 是否显示"跳转到"部分，默认true显示
					showRowsPerPage: true, // 是否显示"每页显示条数"部分，默认true显示
					showRowsInfo: true, // 是否显示记录的信息，默认true显示

					// 用户每次切换页号，都自动触发本函数;
					// 每次返回切换页号之后的pageNo和pageSize
					onChangePage: function (event, pageObj) { // returns page_num and rows_per_page after a link has clicked
						// 重写发送当前页数和每页显示的条数（这也就意味着每次换页都将向后端 发送请求 查询当页数据）
						queryClueByConditionForPage(pageObj.currentPage, pageObj.rowsPerPage);
					}
				});
			}
		});
	}
</script>
</head>
<body>

<!-- 创建线索的模态窗口 -->
<div class="modal fade" id="createClueModal" role="dialog">
	<div class="modal-dialog" role="document" style="width: 90%;">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">
					<span aria-hidden="true">×</span>
				</button>
				<h4 class="modal-title" id="myModalLabel">创建线索</h4>
			</div>
			<div class="modal-body">
				<form id="createClueForm" class="form-horizontal" role="form">

					<div class="form-group">
						<label for="create-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
						<div class="col-sm-10" style="width: 300px;">
							<select class="form-control" id="create-owner">
								<c:forEach items="${userList}" var="u">
									<option value="${u.id}">${u.name}</option>
								</c:forEach>
							</select>
						</div>
						<label for="create-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="create-company">
						</div>
					</div>

					<div class="form-group">
						<label for="create-appellation" class="col-sm-2 control-label">称呼</label>
						<div class="col-sm-10" style="width: 300px;">
							<select class="form-control" id="create-appellation">
								<option></option>
								<c:forEach items="${appellationList}" var="app">
									<option value="${app.id}">${app.value}</option>
								</c:forEach>
							</select>
						</div>
						<label for="create-fullname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="create-fullname">
						</div>
					</div>

					<div class="form-group">
						<label for="create-job" class="col-sm-2 control-label">职位</label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="create-job">
						</div>
						<label for="create-email" class="col-sm-2 control-label">邮箱</label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="create-email">
						</div>
					</div>

					<div class="form-group">
						<label for="create-phone" class="col-sm-2 control-label">公司座机</label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="create-phone">
						</div>
						<label for="create-website" class="col-sm-2 control-label">公司网站</label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="create-website">
						</div>
					</div>

					<div class="form-group">
						<label for="create-mphone" class="col-sm-2 control-label">手机</label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="create-mphone">
						</div>
						<label for="create-state" class="col-sm-2 control-label">线索状态</label>
						<div class="col-sm-10" style="width: 300px;">
							<select class="form-control" id="create-state">
								<option></option>
								<c:forEach items="${clueStateList}" var="cs">
									<option value="${cs.id}">${cs.value}</option>
								</c:forEach>
							</select>
						</div>
					</div>

					<div class="form-group">
						<label for="create-source" class="col-sm-2 control-label">线索来源</label>
						<div class="col-sm-10" style="width: 300px;">
							<select class="form-control" id="create-source">
								<option></option>
								<c:forEach items="${sourceList}" var="sl">
									<option value="${sl.id}">${sl.value}</option>
								</c:forEach>
							</select>
						</div>
					</div>


					<div class="form-group">
						<label for="create-description" class="col-sm-2 control-label">线索描述</label>
						<div class="col-sm-10" style="width: 81%;">
							<textarea class="form-control" rows="3" id="create-description"></textarea>
						</div>
					</div>

					<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

					<div style="position: relative;top: 15px;">
						<div class="form-group">
							<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
							</div>
						</div>
						<div class="form-group">
							<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-nextContactTime">
							</div>
						</div>
					</div>

					<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

					<div style="position: relative;top: 20px;">
						<div class="form-group">
							<label for="create-address" class="col-sm-2 control-label">详细地址</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="1" id="create-address"></textarea>
							</div>
						</div>
					</div>
				</form>

			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
				<button type="button" class="btn btn-primary" id="saveCreateClueBtn">保存</button>
			</div>
		</div>
	</div>
</div>

<!-- 修改线索的模态窗口 -->
<div class="modal fade" id="editClueModal" role="dialog">
	<div class="modal-dialog" role="document" style="width: 90%;">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">
					<span aria-hidden="true">×</span>
				</button>
				<h4 class="modal-title">修改线索</h4>
			</div>
			<div class="modal-body">
				<form class="form-horizontal" role="form">
					<!--设置一个隐藏标签，用来存放id，供后面修改数据时操作-->
					<input type="hidden" id="edit-id">
					<div class="form-group">
						<label for="edit-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
						<div class="col-sm-10" style="width: 300px;">
							<select class="form-control" id="edit-clueOwner">
								<c:forEach items="${userList}" var="u">
									<option value="${u.id}">${u.name}</option>
								</c:forEach>
							</select>
						</div>
						<label for="edit-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="edit-company" value="动力节点">
						</div>
					</div>

					<div class="form-group">
						<label for="edit-call" class="col-sm-2 control-label">称呼</label>
						<div class="col-sm-10" style="width: 300px;">
							<select class="form-control" id="edit-call">
								<option></option>
								<c:forEach items="${appellationList}" var="app">
									<option value="${app.id}">${app.value}</option>
								</c:forEach>
							</select>
						</div>
						<label for="edit-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="edit-surname" value="李四">
						</div>
					</div>

					<div class="form-group">
						<label for="edit-job" class="col-sm-2 control-label">职位</label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="edit-job" value="CTO">
						</div>
						<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="edit-email" value="lisi@bjpowernode.com">
						</div>
					</div>

					<div class="form-group">
						<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="edit-phone" value="010-84846003">
						</div>
						<label for="edit-website" class="col-sm-2 control-label">公司网站</label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="edit-website" value="http://www.bjpowernode.com">
						</div>
					</div>

					<div class="form-group">
						<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="edit-mphone" value="12345678901">
						</div>
						<label for="edit-status" class="col-sm-2 control-label">线索状态</label>
						<div class="col-sm-10" style="width: 300px;">
							<select class="form-control" id="edit-status">
								<option></option>
								<c:forEach items="${clueStateList}" var="cs">
									<option value="${cs.id}">${cs.value}</option>
								</c:forEach>
							</select>
						</div>
					</div>

					<div class="form-group">
						<label for="edit-source" class="col-sm-2 control-label">线索来源</label>
						<div class="col-sm-10" style="width: 300px;">
							<select class="form-control" id="edit-source">
								<option></option>
								<c:forEach items="${sourceList}" var="sl">
									<option value="${sl.id}">${sl.value}</option>
								</c:forEach>
							</select>
						</div>
					</div>

					<div class="form-group">
						<label for="edit-describe" class="col-sm-2 control-label">描述</label>
						<div class="col-sm-10" style="width: 81%;">
							<textarea class="form-control" rows="3" id="edit-describe">这是一条线索的描述信息</textarea>
						</div>
					</div>

					<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

					<div style="position: relative;top: 15px;">
						<div class="form-group">
							<label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-contactSummary">这个线索即将被转换</textarea>
							</div>
						</div>
						<div class="form-group">
							<label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-nextContactTime" value="2017-05-01">
							</div>
						</div>
					</div>

					<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

					<div style="position: relative;top: 20px;">
						<div class="form-group">
							<label for="edit-address" class="col-sm-2 control-label">详细地址</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="1" id="edit-address">北京大兴区大族企业湾</textarea>
							</div>
						</div>
					</div>
				</form>

			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
				<button type="button" class="btn btn-primary" data-dismiss="modal">更新</button>
			</div>
		</div>
	</div>
</div>


<div>
	<div style="position: relative; left: 10px; top: -10px;">
		<div class="page-header">
			<h3>线索列表</h3>
		</div>
	</div>
</div>

<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">

	<div style="width: 100%; position: absolute;top: 5px; left: 10px;">

		<div class="btn-toolbar" role="toolbar" style="height: 80px;">
			<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

				<div class="form-group">
					<div class="input-group">
						<div class="input-group-addon">名称</div>
						<input class="form-control" type="text">
					</div>
				</div>

				<div class="form-group">
					<div class="input-group">
						<div class="input-group-addon">公司</div>
						<input class="form-control" type="text">
					</div>
				</div>

				<div class="form-group">
					<div class="input-group">
						<div class="input-group-addon">公司座机</div>
						<input class="form-control" type="text">
					</div>
				</div>

				<div class="form-group">
					<div class="input-group">
						<div class="input-group-addon">线索来源</div>
						<select class="form-control">
							<option></option>
							<c:forEach items="${sourceList}" var="sl">
								<option value="${sl.id}">${sl.value}</option>
							</c:forEach>
						</select>
					</div>
				</div>

				<br>

				<div class="form-group">
					<div class="input-group">
						<div class="input-group-addon">所有者</div>
						<input class="form-control" type="text">
					</div>
				</div>



				<div class="form-group">
					<div class="input-group">
						<div class="input-group-addon">手机</div>
						<input class="form-control" type="text">
					</div>
				</div>

				<div class="form-group">
					<div class="input-group">
						<div class="input-group-addon">线索状态</div>
						<select class="form-control">
							<option></option>
							<c:forEach items="${clueStateList}" var="cs">
								<option value="${cs.id}">${cs.value}</option>
							</c:forEach>
						</select>
					</div>
				</div>

				<button type="submit" class="btn btn-default">查询</button>

			</form>
		</div>
		<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 40px;">
			<div class="btn-group" style="position: relative; top: 18%;">
				<button type="button" class="btn btn-primary" id="createClueBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				<button type="button" class="btn btn-default" data-toggle="modal" data-target="#editClueModal"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				<button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
			</div>


		</div>
		<div style="position: relative;top: 50px;">
			<table class="table table-hover">
				<thead>
				<tr style="color: #B3B3B3;">
					<td><input type="checkbox" /></td>
					<td>名称</td>
					<td>公司</td>
					<td>公司座机</td>
					<td>手机</td>
					<td>线索来源</td>
					<td>所有者</td>
					<td>线索状态</td>
				</tr>
				</thead>
				<tbody id="tBody">
<%--				<tr>--%>
<%--					<td><input type="checkbox" /></td>--%>
<%--					<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/clue/detailClue.do?id=3c3ef3b3c9c34e15826da6a99dfd90f6';">张三教授</a></td>--%>
<%--					<td>动力节点</td>--%>
<%--					<td>010-84846003</td>--%>
<%--					<td>12345678901</td>--%>
<%--					<td>广告</td>--%>
<%--					<td>zhangsan</td>--%>
<%--					<td>已联系</td>--%>
<%--				</tr>--%>
<%--				<tr class="active">--%>
<%--					<td><input type="checkbox" /></td>--%>
<%--					<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">李四先生</a></td>--%>
<%--					<td>动力节点</td>--%>
<%--					<td>010-84846003</td>--%>
<%--					<td>12345678901</td>--%>
<%--					<td>广告</td>--%>
<%--					<td>zhangsan</td>--%>
<%--					<td>已联系</td>--%>
<%--				</tr>--%>
				</tbody>
			</table>
			<div id="page-master"></div>
		</div>

<%--		<div style="height: 50px; position: relative;top: 60px;">--%>
<%--			<div>--%>
<%--				<button type="button" class="btn btn-default" style="cursor: default;">共<b>50</b>条记录</button>--%>
<%--			</div>--%>
<%--			<div class="btn-group" style="position: relative;top: -34px; left: 110px;">--%>
<%--				<button type="button" class="btn btn-default" style="cursor: default;">显示</button>--%>
<%--				<div class="btn-group">--%>
<%--					<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">--%>
<%--						10--%>
<%--						<span class="caret"></span>--%>
<%--					</button>--%>
<%--					<ul class="dropdown-menu" role="menu">--%>
<%--						<li><a href="#">20</a></li>--%>
<%--						<li><a href="#">30</a></li>--%>
<%--					</ul>--%>
<%--				</div>--%>
<%--				<button type="button" class="btn btn-default" style="cursor: default;">条/页</button>--%>
<%--			</div>--%>
<%--			<div style="position: relative;top: -88px; left: 285px;">--%>
<%--				<nav>--%>
<%--					<ul class="pagination">--%>
<%--						<li class="disabled"><a href="#">首页</a></li>--%>
<%--						<li class="disabled"><a href="#">上一页</a></li>--%>
<%--						<li class="active"><a href="#">1</a></li>--%>
<%--						<li><a href="#">2</a></li>--%>
<%--						<li><a href="#">3</a></li>--%>
<%--						<li><a href="#">4</a></li>--%>
<%--						<li><a href="#">5</a></li>--%>
<%--						<li><a href="#">下一页</a></li>--%>
<%--						<li class="disabled"><a href="#">末页</a></li>--%>
<%--					</ul>--%>
<%--				</nav>--%>
<%--			</div>--%>
<%--		</div>--%>

	</div>

</div>
</body>
</html>
