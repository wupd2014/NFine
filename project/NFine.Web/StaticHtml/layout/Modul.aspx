<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Modul.aspx.cs" Inherits="GYLYEQ.AppSupport.layout.Modul" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
    <title>表单构建器</title>
    <link href="css/bootstrap.min.css" rel="stylesheet" />
    <link href="css/animate.css" rel="stylesheet" />
    <link href="css/style.css" rel="stylesheet" />
    <link href="../../Scripts/jbox/Blue/jbox.css" rel="stylesheet" type="text/css" />
    <link href="../../Styles/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        section hgroup
        {
            text-indent: 2px;
            background: #fff;
            border-bottom: 1px solid #e1e1e1;
            height: 30px;
            line-height: 30px;
            font-size: 14px;
            color: #6a6f73;
            width: 100%;
            position: fixed;
            z-index: 1;
        }
        section hgroup a
        {
            color: #6a6f73;
            font-size: 14px;
            font-family: '微软雅黑';
        }
        section hgroup a
        {
            color: #6a6f73;
        }
        a
        {
            text-decoration: none;
        }
        .form-control
        {
            width: 80%;
        }
        .border_style{border-color:#1ab394 !important;}
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <section>
        <hgroup><span class="icon-home"></span>当前位置：<a href="#">业务建模</a> 》<a href="#">表单管理</a></hgroup>
        <div id="wrapper">
        <div id="page-wrapper" class="gray-bg dashbard-1">
            <div class="wrapper wrapper-content">
                <div class="row">
                    <div class="col-sm-12">
                        <div class="ibox float-e-margins">
                            <div class="ibox-title">
                                <h5>
                                    <%=formName%></h5>
<%--                                <div class="ibox-tools">
                                    请选择显示的列数：
                                    <select id="n-columns">
                                        <option value="1">显示1列</option>
                                        <option value="2">显示2列</option>
                                    </select>
                                </div>--%>
                            </div>
                            <div class="ibox-content">
                                <div class="row form-body form-horizontal m-t">
                                    <div class="col-md-12 droppable sortable ui-droppable ui-sortable" style="display: none;"
                                        runat="server" id="OneColumnDiv">
                                        <asp:Repeater ID="OneColumnRepeater" runat="server">
                                            <ItemTemplate>
                                                <div class="form-group" style="position: static;">
                                                    <label class="col-sm-3 control-label">
                                                        <%#Eval("CONTROLNAME") %></label>
                                                    <div class="col-sm-9" filed='<%#Eval("CONTROLFIELD")%>' isfield="true" data_option='<%#Eval("CONTROLREQUIRE")%>' >
                                                        <%#Eval("CONTROLHTML")%>
                                                    </div>
                                                </div>
                                            </ItemTemplate>
                                        </asp:Repeater>
                                    </div>
                                    <div class="col-md-6" style="" runat="server"
                                        id="TwoColDiv_1">
                                        <asp:Repeater ID="oddRepeater" runat="server">
                                            <ItemTemplate>
                                                <div class="form-group" style="position: static;">
                                                    <label class="col-sm-3 control-label">
                                                        <%#Eval("CONTROLNAME") %>
                                                    </label>
                                                    <div class="col-sm-9" filed='<%#Eval("CONTROLFIELD")%>' isfield="true" data_option='<%#Eval("CONTROLREQUIRE")%>'>
                                                        <%#Eval("CONTROLHTML")%>
                                                    </div>
                                                </div>
                                            </ItemTemplate>
                                        </asp:Repeater>
                                    </div>
                                    <div class="col-md-6" style="" runat="server"
                                        id="TwoColDiv_2">
                                        <asp:Repeater ID="evenRepeater" runat="server">
                                            <ItemTemplate>
                                                <div class="form-group" style="position: static;">
                                                    <label class="col-sm-3 control-label">
                                                        <%#Eval("CONTROLNAME") %>
                                                    </label>
                                                    <div class="col-sm-9" filed='<%#Eval("CONTROLFIELD")%>' isfield="true" data_option='<%#Eval("CONTROLREQUIRE")%>' >
                                                        <%#Eval("CONTROLHTML")%>
                                                    </div>
                                                </div>
                                            </ItemTemplate>
                                        </asp:Repeater>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group" style="position: static;">
                                        <label class="col-sm-3 control-label"></label>
                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <div class="form-group" style="position: static;">
                                            <label class="col-sm-3 control-label">
                                                <button type="submit" class="btn btn-warning" data-clipboard-text="testing" id="save-to-db">
                                                    保存</button>
                                            </label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
            <!-- 模态框（Modal） -->
            <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                            <h4 class="modal-title" id="myModalLabel">是否继续添加</h4>
                        </div>
                        <div class="modal-body">添加成功，是否继续添加？</div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-default" data-dismiss="modal" id='btnlook'>查看信息</button>
                            <button type="button" class="btn btn-primary" id='btnAdd'>继续添加</button>
                        </div>
                    </div><!-- /.modal-content -->
                </div><!-- /.modal-dialog -->
            </div>
            <!-- /.modal -->
            <!-- 模态框（Modal） -->
            <div class="modal fade" id="myModal1" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                            <h4 class="modal-title" id="H1">提示信息</h4>
                        </div>
                        <div class="modal-body">请输入信息</div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-default" data-dismiss="modal" id='Button1'>确定</button>
                        </div>
                    </div><!-- /.modal-content -->
                </div><!-- /.modal-dialog -->
            </div>
            <!-- /.modal -->
    </div>
    </section>
    <input type="hidden" id="hidEmptyInputID" value="" />
    </form>
</body>
</html>
<!--Jquery-->
<script src="../../Scripts/jquery-1.8.3.min.js" type="text/javascript"></script>
<script src="../../Scripts/jquery.jBox-2.3.min.js" type="text/javascript"></script>
<script src="../../Scripts/bootstrap.min.js" type="text/javascript"></script>
<script type="text/javascript">
    // 对Date的扩展，将 Date 转化为指定格式的String
    // 月(M)、日(d)、小时(h)、分(m)、秒(s)、季度(q) 可以用 1-2 个占位符， 
    // 年(y)可以用 1-4 个占位符，毫秒(S)只能用 1 个占位符(是 1-3 位的数字) 
    // 例子： 
    // (new Date()).Format("yyyy-MM-dd hh:mm:ss.S") ==> 2006-07-02 08:09:04.423 
    // (new Date()).Format("yyyy-M-d h:m:s.S")      ==> 2006-7-2 8:9:4.18 
    Date.prototype.Format = function (fmt) { //author: meizz 
        var o = {
            "M+": this.getMonth() + 1, //月份 
            "d+": this.getDate(), //日 
            "h+": this.getHours(), //小时 
            "m+": this.getMinutes(), //分 
            "s+": this.getSeconds(), //秒 
            "q+": Math.floor((this.getMonth() + 3) / 3), //季度 
            "S": this.getMilliseconds() //毫秒 
        };
        if (/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
        for (var k in o)
            if (new RegExp("(" + k + ")").test(fmt)) fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
        return fmt;
    }
    //判断输入的是否为非空
    function IsEmptyInput(obj) {
        if (obj.replace(/^\s+|\s+$/g, '') == '')
            return false;
        else
            return true;
    };
    function checkForm() {
        var fl = true;
        //进行数据校验
        $("div[data_option='required'").each(function () {
            var requireInputs = $(this).children().find("input[type='text']");
            var className = $(this).children().attr("class");
            if (className == "form-control") {
                value = $(this).children().val();
                if (!IsEmptyInput(value)) {
                    $(this).children().focus().addClass('border_style');
                    fl = false;
                    return false;
                } else {
                    $(this).children().removeClass('border_style');
                }
            } else if (className == "radio-inline") {

            } else {

            }
        });
        return fl;
    }
    $(function () {
        //进行数据保存操作
        $("#save-to-db").bind("click", function (ec) {
            if (!checkForm()) {
                //alert('请输入信息');
                $("#myModal1").modal('show');
            } else {
                //参数序列化
                var fileds = $("[isfield='true']");
                var datafieldArr = [];
                fileds.each(function (index) {
                    var key = $(this).attr("filed");
                    var value = "";
                    var className = $(this).children().attr("class");
                    if (className == "form-control") {
                        value = $(this).children().val();
                    } else if (className == "radio-inline") {
                        value = $(this).children().find("[type='radio']:checked")[0].nextSibling.data
                    } else {
                        var $checkboxs = $(this).children().find("[type='checkbox']:checked");
                        $checkboxs.each(function (index) {
                            value += $(this)[0].nextSibling.data + ",";
                        });
                    }
                    datafieldArr.push({ field: key, value: value });
                });

                //上传附件
                upload();
                //保存数据信息
                $.ajax({
                    type: "post",
                    url: "Handler1.ashx?type=savedata&formID=<%=formID%>",
                    data: "data=" + JSON.stringify(datafieldArr),
                    contentType: "application/x-www-form-urlencoded; charset=utf-8",
                    dataType: "text",
                    success: function (data) {
                        $('#myModal').modal({
                            keyboard: true
                        })
                        //$.jBox.prompt('保存成功！', '提示', 'success', { buttons: { '查看': 'ok', '继续添加': 'jxtj' }, submit: function (v, h, f) { if (v == 'ok') { window.location.href = 'DataList.aspx?formID=<%=formID%>'; } else { window.location.href = 'Modul.aspx?formID=<%=formID%>'; } } });
                    }
                });
            }
            return false;
        });

        function upload() {
            var formData = new FormData();
            formData.append("myfile", $("input[type='file']")[0].files[0]);
            $.ajax({
                url: "Handler1.ashx?type=upload",
                type: "POST",
                data: formData,
                /**
                *必须false才会自动加上正确的Content-Type
                */
                contentType: false,
                /**
                * 必须false才会避开jQuery对 formdata 的默认处理
                * XMLHttpRequest会对 formdata 进行正确的处理
                */
                processData: false,
                success: function (data) {
                    if (data == "true") {
                        $.jBox.tip("上传成功！");
                    }
                    else {
                        $.jBox.tip("上传失败！");
                    }

                }
            });

        };

        $("#btnAdd").click(function () {
            //window.location.href = 'DataList.aspx?formID=<%=formID%>'; } else { window.location.href = 'Modul.aspx?formID=<%=formID%>'; 
            $(':input', '#form1').not(':button, :submit, :reset, :hidden').val('').removeAttr('checked').removeAttr('selected');
            //document.getElementById('myModal').style.display = 'none';
            //$("#myModal").removeClass('in').attr("style", "display:none");
            $('#myModal').modal('hide');
        });

        $("#btnlook").click(function () {
            window.location.href = 'DataList.aspx?formID=<%=formID%>';
        });
    });
</script>
