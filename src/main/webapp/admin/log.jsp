<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="java.net.URLEncoder"%>
<%
try{
String str = new String(request.getParameter("keywords").toString().getBytes("ISO-8859-1"));
request.setAttribute("keywords", str);
}
catch(Exception e){

}
%>

<jsp:include page="include/menu.jsp"/>

			<link href="assets/css/bootstrap.min.css" rel="stylesheet" />
			<link rel="stylesheet" href="assets/css/ui.jqgrid.css" />
			<link rel="stylesheet" href="assets/css/ace.min.css" />
				<div class="page-header">
					<h1>
						文章管理
						<small>
							<i class="icon-double-angle-right"></i>
							查看所有文章
						</small>
					</h1>
					<div class="nav-search" style="padding-top: 7px;">
							<form class="form-search">
								<span class="input-icon">
									<input type="text" name="keywords" value="${keywords}" placeholder="请输入关键字..." class="input-small nav-search-input" autocomplete="off">
									<i class="icon-search nav-search-icon"></i>
								</span>
							</form>
					</div>
				</div><!-- /.page-header -->
				<div class="col-xs-12">

					<!-- PAGE CONTENT BEGINS -->

					<table id="grid-table"></table>

					<div id="grid-pager"></div>

					<!-- PAGE CONTENT ENDS -->
				</div><!-- /.col -->
			</div><!-- /.page-content -->
		</div><!-- /.main-content -->
	</div><!-- /.main-container-inner -->
</div><!-- /.main-container -->

		<style>
			.modal-edit {
				width:1300px;
			}
		</style>
		<script type="text/javascript" src="assets/js/eModal.min.js"></script>
		<script type="text/javascript">
			function open2(id,catalog,title){
				var options = {
					"url":"${url}/admin/log/editFrame?logId="+id,
					"title":decodeURI(title),
					"size":"edit"
				}
				eModal.iframe(options);
			}
		</script>
		<script src="assets/js/date-time/bootstrap-datepicker.min.js"></script>
		<script src="assets/js/jqGrid/jquery.jqGrid.min.js"></script>
		<script src="assets/js/jqGrid/i18n/grid.locale-cn.js"></script>
		<script type="text/javascript">

			var jqGrid;

			jQuery(function($) {
				var grid_selector = "#grid-table";
				var pager_selector = "#grid-pager";
				
				jqGrid = jQuery(grid_selector).jqGrid({
					
				url:'${url}/admin/log/queryAll?keywords=${keywords}',
				datatype: "json",
					colNames:['编辑','删除','id','标题','关键词', '发布者', '分类','发布时间','查看数','草稿','私有','浏览'],
					colModel:[
						{name:'logId',width:50,index:'logId',sortable:false,formatter:imageFormat},
						{name:'myac',width:50,index:'',sorttype:"int", editable: true, width:50, fixed:true, sortable:false, resize:false,
							 formatter: 'actions',
						      formatoptions: {
						       keys: true,
						       editbutton:false,	
						       delbutton: true,
						       delOptions: {recreateForm: true, beforeShowForm:beforeDeleteCallback, url: '${url}/admin/log/delete' }
						      }
						},      
						{name:'id',index:'id', width:60, sorttype:"int", editable: true},
						{name:'title',index:'title',width:220, sortable:false,editable: true,edittype:"textarea", editoptions:{rows:"2",cols:"20"}},
						{name:'keywords',index:'keywords', width:180,editable: true,editoptions:{size:"20",maxlength:"30"}},
						{name:'userName',index:'userName', width:60, editable: false},
						{name:'typeName',index:'typeName', width:90, editable: true,edittype:"select",editoptions:{value:"FE:FedEx;IN:InTime;TN:TNT;AR:ARAMEX"}},
						
						{name:'releaseTime',index:'releaseTime',width:130, editable:true, sorttype:"date",unformat: pickDate},
						{name:'click',index:'click', width:60, editable: false},
						{name:'rubbish',index:'rubbish', width:50, editable: false,formatter:renderRubbish},
						{name:'private',index:'private', width:50, editable: false,formatter:renderPrivate},
						{name:'logId',width:50,index:'logId',formatter:viewLog},
					],
					viewrecords : true,
					rowNum:10,
					rowList:[10,20,30],
					pager : pager_selector,
					altRows: true,
					//toppager: true,
					editurl:'${url}/admin/log/delete',
					multiselect: true,
					//multikey: "ctrlKey",
			        multiboxonly: true,
			
					loadComplete : function() {
						var table = this;
						setTimeout(function(){
							styleCheckbox(table);
							
							updateActionIcons(table);
							updatePagerIcons(table);
							enableTooltips(table);
						}, 0);
					},
			
					caption: "文章管理",
					height:391,
			
					autowidth: true
			
				});
			
				//enable search/filter toolbar
				//jQuery(grid_selector).jqGrid('filterToolbar',{defaultSearch:true,stringResult:true})
				function imageFormat( cellvalue, options, rowObject ){
					return '<div><div id="jEditButton_2" class="ui-pg-div ui-inline-edit" onmouseout="jQuery(this).removeClass(\'ui-state-hover\')" onmouseover="jQuery(this).addClass(\'ui-state-hover\');" onclick="open2('+rowObject.logId+',\''+rowObject.catalog+'\',\''+rowObject.title.replace("'","")+'\');" style="float: left; cursor: pointer; display: block;" title="" data-original-title="编辑所选记录"><span class="ui-icon ui-icon-pencil"></span></div></div>'
				}
				function viewLog( cellvalue, options, rowObject ){
					return '<a target="_blank" href="${url}/admin/log/preview?logId='+rowObject.logId+'"><div id="jEditButton_2" class="ui-pg-div ui-inline-edit" onmouseout="jQuery(this).removeClass(\'ui-state-hover\')" onmouseover="jQuery(this).addClass(\'ui-state-hover\');" style="float: left; cursor: pointer; display: block;" title="" data-original-title="浏览  '+rowObject.title+'"><span class="ui-icon icon-zoom-in blue"></span></div></a>'
				}
				function renderPrivate( cellvalue, options, rowObject ){
					if(rowObject.private){
						return '是'
					}
					return '否'
				}

				function renderRubbish( cellvalue, options, rowObject ){
					if(rowObject.rubbish){
						return '是'
					}
					return '否'
				}

				//switch element when editing inline
				function aceSwitch( cellvalue, options, cell ) {
					setTimeout(function(){
						$(cell) .find('input[type=checkbox]')
								.wrap('<label class="inline" />')
							.addClass('ace ace-switch ace-switch-5')
							.after('<span class="lbl"></span>');
					}, 0);
				}
				//enable datepicker
				function pickDate( cellvalue, options, cell ) {
					setTimeout(function(){
						$(cell) .find('input[type=text]')
								.datepicker({format:'yyyy-mm-dd' , autoclose:true});
					}, 0);
				}


				//navButtons
				jQuery(grid_selector).jqGrid('navGrid',pager_selector,
					{ 	//navbar options
						edit: false,
						editicon : 'icon-pencil blue',
						add: false,
						addicon : 'icon-plus-sign purple',
						del: true,
						delicon : 'icon-trash red',
						search: false,
						searchicon : 'icon-search orange',
						refresh: false,
						refreshicon : 'icon-refresh green',
						view: false,
						viewicon : 'icon-zoom-in grey',
					},
					{
						//edit record form
						//closeAfterEdit: true,
						recreateForm: true,
						beforeShowForm : function(e) {
							var form = $(e[0]);
							form.closest('.ui-jqdialog').find('.ui-jqdialog-titlebar').wrapInner('<div class="widget-header" />')
							style_edit_form(form);
						}
					},
					{
						//new record form
						closeAfterAdd: true,
						recreateForm: true,
						viewPagerButtons: false,
						beforeShowForm : function(e) {
							var form = $(e[0]);
							form.closest('.ui-jqdialog').find('.ui-jqdialog-titlebar').wrapInner('<div class="widget-header" />')
							style_edit_form(form);
						}
					},
					{
						//delete record form
						recreateForm: true,
						beforeShowForm : function(e) {
							var form = $(e[0]);
							if(form.data('styled')) return false;

							form.closest('.ui-jqdialog').find('.ui-jqdialog-titlebar').wrapInner('<div class="widget-header" />')
							style_delete_form(form);

							form.data('styled', true);
						},
						onClick : function(e) {
							alert(1);
						}
					},
					{
						//search form
						recreateForm: true,
						afterShowSearch: function(e){
							var form = $(e[0]);
							form.closest('.ui-jqdialog').find('.ui-jqdialog-title').wrap('<div class="widget-header" />')
							style_search_form(form);
						},
						afterRedraw: function(){
							style_search_filters($(this));
						}
						,
						multipleSearch: true,
						/**
						multipleGroup:true,
						showQuery: true
						*/
					},
					{
						//view record form
						recreateForm: true,
						beforeShowForm: function(e){
							var form = $(e[0]);
							form.closest('.ui-jqdialog').find('.ui-jqdialog-title').wrap('<div class="widget-header" />')
						}
					}
				)



				function style_edit_form(form) {
					//enable datepicker on "sdate" field and switches for "stock" field
					form.find('input[name=sdate]').datepicker({format:'yyyy-mm-dd' , autoclose:true})
						.end().find('input[name=stock]')
							  .addClass('ace ace-switch ace-switch-5').wrap('<label class="inline" />').after('<span class="lbl"></span>');

					//update buttons classes
					var buttons = form.next().find('.EditButton .fm-button');
					buttons.addClass('btn btn-sm').find('[class*="-icon"]').remove();//ui-icon, s-icon
					buttons.eq(0).addClass('btn-primary').prepend('<i class="icon-ok"></i>');
					buttons.eq(1).prepend('<i class="icon-remove"></i>')

					buttons = form.next().find('.navButton a');
					buttons.find('.ui-icon').remove();
					buttons.eq(0).append('<i class="icon-chevron-left"></i>');
					buttons.eq(1).append('<i class="icon-chevron-right"></i>');
				}

				function style_delete_form(form) {
					var buttons = form.next().find('.EditButton .fm-button');
					buttons.addClass('btn btn-sm').find('[class*="-icon"]').remove();//ui-icon, s-icon
					buttons.eq(0).addClass('btn-danger').prepend('<i class="icon-trash"></i>');
					buttons.eq(1).prepend('<i class="icon-remove"></i>')
				}

				function style_search_filters(form) {
					form.find('.delete-rule').val('X');
					form.find('.add-rule').addClass('btn btn-xs btn-primary');
					form.find('.add-group').addClass('btn btn-xs btn-success');
					form.find('.delete-group').addClass('btn btn-xs btn-danger');
				}
				function style_search_form(form) {
					var dialog = form.closest('.ui-jqdialog');
					var buttons = dialog.find('.EditTable')
					buttons.find('.EditButton a[id*="_reset"]').addClass('btn btn-sm btn-info').find('.ui-icon').attr('class', 'icon-retweet');
					buttons.find('.EditButton a[id*="_query"]').addClass('btn btn-sm btn-inverse').find('.ui-icon').attr('class', 'icon-comment-alt');
					buttons.find('.EditButton a[id*="_search"]').addClass('btn btn-sm btn-purple').find('.ui-icon').attr('class', 'icon-search');
				}

				function beforeDeleteCallback(e) {
					var form = $(e[0]);
					if(form.data('styled')) return false;

					form.closest('.ui-jqdialog').find('.ui-jqdialog-titlebar').wrapInner('<div class="widget-header" />')
					style_delete_form(form);

					form.data('styled', true);
				}

				function beforeEditCallback(e) {
					var form = $(e[0]);
					form.closest('.ui-jqdialog').find('.ui-jqdialog-titlebar').wrapInner('<div class="widget-header" />')
					style_edit_form(form);
				}



				//it causes some flicker when reloading or navigating grid
				//it may be possible to have some custom formatter to do this as the grid is being created to prevent this
				//or go back to default browser checkbox styles for the grid
				function styleCheckbox(table) {
				/**
					$(table).find('input:checkbox').addClass('ace')
					.wrap('<label />')
					.after('<span class="lbl align-top" />')


					$('.ui-jqgrid-labels th[id*="_cb"]:first-child')
					.find('input.cbox[type=checkbox]').addClass('ace')
					.wrap('<label />').after('<span class="lbl align-top" />');
				*/
				}


				//unlike navButtons icons, action icons in rows seem to be hard-coded
				//you can change them like this in here if you want
				function updateActionIcons(table) {
					/**
					var replacement =
					{
						'ui-icon-pencil' : 'icon-pencil blue',
						'ui-icon-trash' : 'icon-trash red',
						'ui-icon-disk' : 'icon-ok green',
						'ui-icon-cancel' : 'icon-remove red'
					};
					$(table).find('.ui-pg-div span.ui-icon').each(function(){
						var icon = $(this);
						var $class = $.trim(icon.attr('class').replace('ui-icon', ''));
						if($class in replacement) icon.attr('class', 'ui-icon '+replacement[$class]);
					})
					*/
				}

				//replace icons with FontAwesome icons like above
				function updatePagerIcons(table) {
					var replacement =
					{
						'ui-icon-seek-first' : 'icon-double-angle-left bigger-140',
						'ui-icon-seek-prev' : 'icon-angle-left bigger-140',
						'ui-icon-seek-next' : 'icon-angle-right bigger-140',
						'ui-icon-seek-end' : 'icon-double-angle-right bigger-140'
					};
					$('.ui-pg-table:not(.navtable) > tbody > tr > .ui-pg-button > .ui-icon').each(function(){
						var icon = $(this);
						var $class = $.trim(icon.attr('class').replace('ui-icon', ''));

						if($class in replacement) icon.attr('class', 'ui-icon '+replacement[$class]);
					})
				}

				function enableTooltips(table) {
					$('.navtable .ui-pg-button').tooltip({container:'body'});
					$(table).find('.ui-pg-div').tooltip({container:'body'});
				}

				//var selr = jQuery(grid_selector).jqGrid('getGridParam','selrow');
			
			
			});
		</script>
	<div style="display:none"></div>
</body>
</html>