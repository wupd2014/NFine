<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DynamicForm.aspx.cs" Inherits="GYLYEQ.AppSupport.layout.DynamicForm"
    ValidateRequest="false" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title></title>
    <link href="css/bootstrap-combined.min.css" rel="stylesheet">
    <link href="css/layoutit.css" rel="stylesheet">
    <script src="../../Scripts/jquery-1.8.3.min.js" type="text/javascript"></script>
    <link href="../../Styles/CSS.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        $(function () {
            $("#postData").click(function () {
                //alert(decodeURIComponent($("form").serialize(), true));
                $.post('Handler1.ashx?type=savepostdata&layoutid=' + <%=fid%>, { data: decodeURIComponent($("form").serialize(),true) }, function (data) {
                    // 回调
                    alert(data);
                });

            });
              $("input[type=text]").focus(function(){
                    var oldstr=$(this).val()
                    $(this).css("background-color","#FFFFCC").val("").attr("data-option",oldstr);
                });
               $("input").blur(function(){
                    if($(this).val()==""||$(this).val()==undefined){
                    console.log($(this).val())
                        $(this).val($(this).attr("data-option"));
                    }
                    $(this).css("background-color","white");
               });
        });
    </script>
    <style type="text/css">
        .view{ left:50%;margin-top:80px;}
        .top{ margin-top:75px;}
    </style>
</head>
<body style="margin:0 auto">
    <form id="form1" runat="server">
    <section>
        <div class="navbar navbar-inverse navbar-fixed-top">
            <hgroup><span class="icon-home font-sz"></span>当前位置：<a href="#">业务建模</a> 》<a href="#">业务建模</a></hgroup>
        </div>
        <div class="navbar navbar-inverse navbar-fixed-top top">
            <div >
                <div class="container-fluid">
                    <button data-target=".nav-collapse" data-toggle="collapse" class="btn btn-navbar" type="button"> <span class="icon-bar"></span> <span class="icon-bar"></span> <span class="icon-bar"></span> </button>
                    <div class="nav-collapse collapse">
                        <ul class="nav" id="menu-layoutit" style="float:right; margin-right:10%;">
                            <li>
                                <div class="btn-group" data-toggle="buttons-radio">
                                    <input type="button" id='postData' value='保存表单数据' class="sear_bott icon-edit  icon-white" style="width:70px;height:25px" /><
                                    <input type="button" value="查看数据"  class="sear_bott icon-eye-open icon-white" style="width:50px;height:25px" onclick="window.location='UserDataListaspx.aspx?layoutid=<%=fid%>'" />
                                    <input type="button" value="返回"  class="sear_bott icon-eye-open icon-white" style="width:50px;height:25px" onclick="window.location='<%=url%>'" />
                                </div>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
         <%=HTML%>
    <div>
    </div>
    </section>
    </form>
</body>
</html>
