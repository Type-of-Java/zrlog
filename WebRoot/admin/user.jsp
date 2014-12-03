<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<jsp:include page="include/menu.jsp"/>
<link rel="stylesheet" href="${url}/admin/editor/themes/default/default.css" />
<script src="${url}/admin/editor/kindeditor-min.js"></script>
		
<script type="text/javascript" >
	
KindEditor.ready(function(K) {
	var uploadbutton = K.uploadbutton({
		button : K('#uploadButton')[0],
		fieldName : 'imgFile',
		url : '${url}/admin/log/upload?dir=header',
		afterUpload : function(data) {
			if (data.error === 0) {
				var url = K.formatUrl(data.url, 'absolute');
				var dialog = K.dialog({
					width : 500,
					title : '上传成功',
					body : '<div style="margin:10px;"><strong>分类封面上传成功</strong></div>',
					closeBtn : {
						name : '关闭',
						click : function(e) {
						}
					},
					yesBtn : {
						name : '确定',
						click : function(e) {
							dialog.remove();
							K('#logo').val(url);
						}
					},
					noBtn : {
						name : '取消',
						click : function(e) {
							dialog.remove();
						}
					}
				});
				
			} else {
				
			}
		},
		afterError : function(str) {
			alert('自定义错误信息: ' + str);
		}
	});
	uploadbutton.fileBox.change(function(e) {
		uploadbutton.submit();
	});
});

</script>
<script type="text/javascript">
	
	$(function(){
		$("#submit").click(function(){
			if($("#form-field-1").val().length!=0 ){
				
				$.post('${url}/articleType/addArticleType',$('.form-horizontal').serialize(),function(data){
					if('success'==data){
						alert('操作成功！');
						location.href = location.href;
					}else{
						alert('erro:服务器返回了一个错误，操作失败！\n请联系开发人员！！！');
					}
				});
			}else{
				alert('目录,名称,封面都不能为空');
			}
		});
	});
</script>
<div class="page-content">
						<div class="page-header">
							<h1>
								信息设置
								<small>
									<i class="icon-double-angle-right"></i>
									个人信息设置
								</small>
							</h1>
						</div><!-- /.page-header -->

						<div class="row">
							<div class="col-xs-12">
								<!-- PAGE CONTENT BEGINS -->

								<form role="form" class="form-horizontal">
									<div class="form-group">
										<label for="form-field-1" class="col-sm-3 control-label no-padding-right"> 登陆用户名 </label>

										<div class="col-sm-9">
											<input type="text" name="userName" value="${user.userName }" class="col-xs-10 col-sm-5" placeholder="请求输入网站标题 " id="form-field-1">
										</div>
									</div>
									
									<div class="form-group">
										<label for="form-field-1" class="col-sm-3 control-label no-padding-right"> 密码 </label>

										<div class="col-sm-9">
											<input type="text" name="second_title" value="${webs.second_title }" class="col-xs-10 col-sm-5" placeholder="请求输入网站副标题 " id="form-field-1">
											
										</div>
									</div>
									<div class="form-group">
										<label for="form-field-1" class="col-sm-3 control-label no-padding-right"> 网站&nbsp;Logo </label>

										<div class="col-sm-9">
											<div class="upload">
												<input type="text" id="logo" value="${webs.logo }" class="col-xs-10 col-sm-5" name="imgUrl" readonly="readonly" />&nbsp;&nbsp; <input type="button"  id="uploadButton" value="上传" />
											</div>
										</div>
									</div>
									
									<div class="space-4"></div>

									<div class="clearfix form-actions">
										<div class="col-md-offset-3 col-md-9">
											<button id="submit" type="button" class="btn btn-info">
												<i class="icon-ok bigger-110"></i>
												提交
											</button>

											&nbsp; &nbsp; &nbsp;
											<button type="reset" class="btn">
												<i class="icon-undo bigger-110"></i>
												重置
											</button>
										</div>
									</div>

								</form>
								<!-- PAGE CONTENT ENDS -->
							</div><!-- /.col -->
						</div><!-- /.row -->

					</div>
		
	<div style="display:none"></div>
	<body> 
</html>