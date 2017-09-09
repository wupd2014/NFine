<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UserDataListaspx.aspx.cs"
    Inherits="GYLYEQ.AppSupport.layout.UserDataListaspx" %>

<!DOCTYPE html>
<!--[if lt IE 7]>      <html class="no-js lt-ie9 lt-ie8 lt-ie7"> <![endif]-->
<!--[if IE 7]>         <html class="no-js lt-ie9 lt-ie8"> <![endif]-->
<!--[if IE 8]>         <html class="no-js lt-ie9"> <![endif]-->
<!--[if gt IE 8]><!-->
<html class="no-js">
<!--<![endif]-->
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title></title>
    <meta name="description" content="">
    <meta name="viewport" content="width=device-width">
    <link href="../../Scripts/mmGrid/normalize.css" rel="stylesheet" type="text/css" />
    <link href="../../Scripts/mmGrid/main.css" rel="stylesheet" type="text/css" />
    <link href="../../Scripts/mmGrid/960.css" rel="stylesheet" type="text/css" />
    <link href="../../Scripts/mmGrid/mmGrid.css" rel="stylesheet" type="text/css" />
    <link href="../../Scripts/mmGrid/mmPaginator.css" rel="stylesheet" type="text/css" />
    <link href="../../Styles/CSS.css" rel="stylesheet" type="text/css" />
    <style>
        html, body
        {
            font-family: 'Helvetica Neue' ,helvetica, "Hiragino Sans GB" , 'Microsoft YaHei' , "WenQuanYi Micro Hei" , sans-serif;
            font-size: 12px;
            color: #444;
        }
        *
        {
            box-sizing: content-box;
            font-size: 12px;
            margin: 0 auto;
        }
        select, #secucode
        {
            padding: 0;
            margin-bottom: 0;
            border-radius: 0;
        }
        .mmg-title .mmg-canSort { text-decoration:none;}
        section hgroup a
        {
            color: #6a6f73;
            font-size:14px;
            font-family: '微软雅黑';
        }
    </style>
    <!--[if lt IE 9]>
         <script type="text/javascript" src="../../Scripts/html5shiv.js"></script>
        <![endif]-->
    <script src="../../Scripts/mmGrid/modernizr-2.6.2.min.js" type="text/javascript"></script>
</head>
<body>
    <form runat="server">
    <section>
       <hgroup><span class="icon-home font-sz"></span>当前位置：<a href="#">业务建模</a> 》<a href="#">业务建模</a></hgroup>
            <main>
                <div style="margin-bottom: 5px; margin-top:40px; margin-left:40px;">
                    表单名称：<asp:DropDownList runat="server" ID="ddlform"   CssClass="sear_text" style="width:165px; height:25px"    AutoPostBack="true" onselectedindexchanged="DropDownList1_SelectedIndexChanged" ></asp:DropDownList>
                    查询字段：<asp:DropDownList runat="server" ID="ddlField" CssClass="sear_text" style="width:165px; height:25px"></asp:DropDownList>
                    <input id="secucode" placeholder="请输入希望查询的内容" style="margin-left: 40px;width:160px;height:23px;" runat="server" class="sear_text"  > 
                    <button type="button" id="btnSearch" class="sear_bott" style="width:65px; height:25px" ><i class=" icon-share icon-white"></i>搜索</button>
                    <button type="button" id="edit" class="sear_bott" style="width:65px;height:25px" onclick="window.location='DynamicForm.aspx?ID=<%=layoutid %>&url=UserDataListaspx.aspx'"><i class="icon-edit icon-white"></i>添加数据</button>
                </div>
                <table id="table11-1" ></table>
                <div style="text-align:right;">
                    <div id="paginator11-1" style="width:98%"></div>
                </div>
            </main>
    </section>
    </form>
    <script src="../../Scripts/jquery-1.9.1.min.js" type="text/javascript"></script>
    <script src="../../Scripts/mmGrid/plugins.js" type="text/javascript"></script>
    <script src="../../Scripts/mmGrid/json2.js" type="text/javascript"></script>
    <script src="../../Scripts/mmGrid/mmGrid.js" type="text/javascript"></script>
    <script src="../../Scripts/mmGrid/mmPaginator.js" type="text/javascript"></script>
    <script type="text/javascript">
            $(document).ready(function () {
            var secucode=$("#secucode").val()
            console.log(secucode);
                //列
                var cols = <%=colstr%>;
                //分页
                var mmg=$('#table11-1').mmGrid({
					height: 460
					, cols: cols
					, url: 'Handler1.ashx?type=showData&layoutid=<%=layoutid%>&Data='+secucode
                    , method: 'get'
                    , remoteSort:true
                    , multiSelect: true
                    , checkCol: true
                    ,params:function(){
                      // alert($("#secucode").val());
                        var con=$("#ddlField").val()+" "+" like '%"+$("#secucode").val()+"%'";
                        return {wheres:con} ;
                    } 
					, plugins: [ $('#paginator11-1').mmPaginator({}) ] //分页插件
                });
                 $('#btnSearch').on('click',function(){
                    mmg.load({page: 1});
                });
                $(".mmg-headWrapper").width($("#table11-1").width());     //通过js调整头部与内容进行对齐

            });
    </script>
</body>
</html>
