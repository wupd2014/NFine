<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DataList.aspx.cs" Inherits="GYLYEQ.AppSupport.layout.DataList" %>

<%@ Register TagPrefix="webdiyer" Namespace="Wuqi.Webdiyer" Assembly="AspNetPager, Version=4.3.0.0, Culture=neutral, PublicKeyToken=fb0a0fe055d40fd4" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link href="../../Styles/CSS.css" rel="stylesheet" type="text/css" />
    <link href="../../Styles/font-awesome.css" rel="stylesheet" type="text/css" />
    <link href="../../Scripts/jbox/Blue/jbox.css" rel="stylesheet" type="text/css" />
    <script src="../../Scripts/jquery-1.4.2.min.js" type="text/javascript"></script>
    <script src="../../Scripts/jquery.jBox-2.3.min.js" type="text/javascript"></script>
    <script type="text/javascript">
        function Del(obj) {
            $.ajax({
                type: "Post",
                url: "DataList.aspx/Del",
                data: "{'ID':'" + obj + "','formid':'" + $("#hidformID").val() + "'}",
                contentType: "application/json;charset=utf-8",
                dataType: "json",
                success: function (res) {
                    $.jBox.tip(res.d);
                    window.location = window.location;
                },
                error: function (d, c, e) {
                    alert(e);
                }
            });

        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server">
    </asp:ScriptManager>
    <section>
             <hgroup><span class="icon-home"></span>当前位置：<a href="#">业务建模</a> 》<a href="#">表单管理</a></hgroup>
            <div style="height: 8px;"></div>
             <table class="search_table" cellspacing="0" cellpadding="0">
                 <tr>
                    <td><h4><%=frmName%></h4></td>
                </tr>
            </table>
             <div class="table">
             <table width="99%" border="0" class="table_all" cellpadding="0" cellspacing="0">
             <%=html%>
             </table>
            </div>
                <webdiyer:AspNetPager ID="AspNetPager1" ShowCustomInfoSection="Left" CustomInfoTextAlign="Left"
                runat="server" HorizontalAlign="Right" FirstPageText="首页" LastPageText="尾页" ShowMoreButtons="true"
                NumericButtonCount="5" PrevPageText="上一页" NextPageText="下一页" AlwaysShow="true" ShowInputBox="Never"
                ShowBoxThreshold="2" PageSize="10"  OnPageChanged="AspNetPager2_OnPageChanged" CssClass="digg"
                CurrentPageButtonClass="current" />
    </section>
    <asp:HiddenField ID="hidformID" runat="server" />
    </form>
</body>
</html>
