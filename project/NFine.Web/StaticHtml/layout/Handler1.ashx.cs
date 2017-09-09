using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using NSoup.Nodes;
using NSoup.Select;
using Maticsoft.BLL;
using BLL;
using DAL;
using System.Text;
using System.Data;
using System.Web.Script.Serialization;
using Newtonsoft.Json;
using System.IO;
using GYLYEQ.BLL;
using GYLYEQ.DBUtility;

namespace Layout.layout
{
    /// <summary>
    /// Handler1 的摘要说明
    /// </summary>
    public class Handler1 : IHttpHandler
    {
        public string result = "";
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";

            string type = context.Request.QueryString["type"];
            string Data = context.Request.Form["data"];
            string layoutid = context.Request.QueryString["layoutid"];

            FORM_BUILDER_FORM frmBll = new FORM_BUILDER_FORM();
            GYLYEQ.Model.FORM_BUILDER_FORM frmModel = new GYLYEQ.Model.FORM_BUILDER_FORM();

            FORM_BUILDER_CONTROL cntrBll = new FORM_BUILDER_CONTROL();
            GYLYEQ.Model.FORM_BUILDER_CONTROL cntrModel = new GYLYEQ.Model.FORM_BUILDER_CONTROL();

            switch (type)
            {
                case "savelayout":
                    string formName = context.Request.QueryString["formName"];
                    savelayout(Data, formName);     //创建自定义表单模板数据及动态表
                    break;
                case "savepostdata":
                    savepostdata(Data, layoutid);   //插入自定义表单用户数据
                    break;
                case "showData":
                    string pageindex = context.Request.QueryString["page"];
                    string pagesize = context.Request.QueryString["limit"];
                    string wheres = context.Request.Params["wheres"];
                    GetJsonData(pageindex, pagesize, wheres, layoutid);
                    break;
                case "save":

                    var mRequest = HttpContext.Current.Request.Form["data"];
                    string formTitle = HttpContext.Current.Server.UrlDecode(HttpContext.Current.Request.QueryString["formTitle"]);
                    string columns = HttpContext.Current.Request.QueryString["columns"];
                    string tabName = string.Format("FORM_BUILDER_{0}", DateTime.Now.ToString("yyyyMMddHHmmss"));
                    List<formControl> clist = JsonConvert.DeserializeObject<List<formControl>>(mRequest);
                    frmModel.FORMID = DbHelperOra.GetMaxID("FORMID", "FORM_BUILDER_FORM");
                    frmModel.FORMNAME = formTitle;
                    frmModel.FORMCREATETIME = DateTime.Now;
                    frmModel.FORMCOLUMNS = int.Parse(columns);
                    frmModel.FORMREMARK = formTitle;
                    frmModel.FORMTABLE = tabName;
                    frmBll.Add(frmModel);

                    foreach (formControl item in clist)
                    {
                        cntrModel.CONTROLID = DbHelperOra.GetMaxID("CONTROLID", "FORM_BUILDER_CONTROL");
                        cntrModel.CONTROLNAME = item.name;
                        cntrModel.CONTROLSORT = item.sort.ToString();
                        cntrModel.CONTROLREQUIRE = item.required;
                        cntrModel.CONTROLREMARK = item.remark;
                        cntrModel.CONTROLHTML = item.html;
                        cntrModel.FORMID = frmModel.FORMID;
                        cntrModel.CONTROLFIELD = item.field;
                        cntrBll.Add(cntrModel);
                    }
                    //创建对应的业务表
                    CreateTable(clist, tabName);

                    break;
                case "savedata":
                    var data = HttpContext.Current.Request.Form["data"];
                    List<dataModel> llist = JsonConvert.DeserializeObject<List<dataModel>>(data);
                    string formID = HttpContext.Current.Request.QueryString["formID"];
                    string inserTableName = frmBll.GetModel(decimal.Parse(formID)).FORMTABLE;
                    insertData(inserTableName, llist);

                    //进行数据插入
                    break;
                case "upload":
                    UpLoadFile(context);
                    break;
                default:
                    break;
            }
            context.Response.Write(result);
        }

        //上传文件
        private void UpLoadFile(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            if (context.Request.Files.Count > 0)
            {
                var myFile = context.Request.Files["myfile"];
                myFile.SaveAs(context.Server.MapPath("~/UploadFiles/FormBuilder/") + myFile.FileName);//保存文件
                context.Response.Write("true");
                return;
            }
        }

        //插入数据
        private void insertData(string inserTableName, List<dataModel> llist)
        {

            string CONTROLID = DbHelperOra.GetMaxID("CONTROLID", inserTableName).ToString();
            StringBuilder insertSb = new StringBuilder();
            List<string> fieldlist = new List<string>();
            List<string> valuelist = new List<string>();
            fieldlist.Add("CONTROLID");
            valuelist.Add(string.Format("'{0}'", CONTROLID));
            foreach (dataModel item in llist)
            {
                fieldlist.Add(item.field);
                valuelist.Add(string.Format("'{0}'", item.value));
            }
            insertSb.AppendFormat("insert into {0} ({1}) values ({2})", inserTableName, string.Join(",", fieldlist), string.Join(",", valuelist));
            try
            {
                int rows = DbHelperOra.ExecuteSql(insertSb.ToString());
                result = "保存成功";
            }
            catch (Exception ex)
            {
                result = ex.Message;
            }
        }

        private void CreateTable(List<formControl> clist, string tabName)
        {

            StringBuilder sb = new StringBuilder();
            sb.AppendFormat(" create table {0}  ( ", tabName);
            sb.Append("   CONTROLID      INTEGER,");
            foreach (formControl item in clist)
            {
                sb.AppendFormat(" {0}  NVARCHAR2(200), ", item.field);
            }
            sb.Remove(sb.Length - 2, 1);
            sb.Append(" ) ");

            string CreateTableSqlStr = sb.ToString();
            try
            {
                int bl = DbHelperOra.ExecuteSql(CreateTableSqlStr);
                result = "保存成功";
            }
            catch (Exception ex)
            {
                result = ex.Message;
            }
        }

        private void GetJsonData(string pageindex, string pagesize, string wheres, string layoutid)
        {
            //string layoutid = "2";
            BLL.LayOutForm bll = new BLL.LayOutForm();
            string layoutTablename = "";
            List<string> list = bll.getTableColName(layoutid, out layoutTablename);     //获取表单对应的表及列名
            string pagecount = "";
            DataTable dt = bll.GetDataTable(layoutTablename, wheres, pageindex, pagesize, out pagecount);
            //将DataTable封装为控件使用的json格式
            productJsonData(dt, pagecount);

        }



        private void productJsonData(DataTable dt, string pagecount)
        {
            //int totalCount = dt.Rows.Count;
            StringBuilder jsonData = new StringBuilder();
            if (dt.Rows.Count > 0)
            {
                jsonData.Append("[");
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    jsonData.Append("{");
                    for (int j = 0; j < dt.Columns.Count; j++)
                    {
                        string tmp = string.Format("\"{0}\":\"{1}\",", dt.Columns[j].ColumnName.ToString().ToLower(), dt.Rows[i][j].ToString());

                        jsonData.Append(tmp);
                    }
                    jsonData.Remove(jsonData.Length - 1, 1);
                    jsonData.Append("},");

                }
                jsonData.Remove(jsonData.Length - 1, 1);
                jsonData.Append("]");
            }
            else
            {
                jsonData.Append("[ ]");
            }
            result = "{" + string.Format("\"totalCount\":{0},\"items\": {1}", pagecount, jsonData.ToString()) + "}";
        }



        private void savepostdata(string Data, string layoutid)
        {
            try
            {
                StringBuilder sb = new StringBuilder();
                BLL.LayOutForm bll = new BLL.LayOutForm();
                string layoutTablename = "";
                List<string> list = bll.getTableColName(layoutid, out layoutTablename);     //获取表单对应的表及列名
                List<KeyValueModel> kvlist = new List<KeyValueModel>();

                var aQuery = Data.Split('&');                                       //post数据处理为List<T>
                for (var i = 0; i < aQuery.Length; i++)
                {
                    var k = aQuery[i].IndexOf("=");
                    if (k == -1) continue;
                    var key = aQuery[i].Substring(0, k);
                    var value = aQuery[i].Substring(k + 1);
                    kvlist.Add(new KeyValueModel
                    {
                        key = key,
                        value = value
                    });
                }
                List<KeyValueModel> flist = fliterList(list, kvlist);               //过滤列对应的用户表单数据
                insertPostData(layoutTablename, flist);                                 //插入数据
                result = "保存成功";
            }
            catch (Exception ex)
            {
                result = ex.Message;
            }
        }

        private void insertPostData(string layoutTablename, List<KeyValueModel> flist)
        {
            BLL.LayOutForm bll = new BLL.LayOutForm();
            bool bl = bll.insertPostData(layoutTablename, flist);
        }

        private List<KeyValueModel> fliterList(List<string> list, List<KeyValueModel> kvlist)
        {
            List<KeyValueModel> temp = new List<KeyValueModel>();
            foreach (var kv in kvlist)
            {
                if (list.Contains(kv.key.ToLower()))
                {
                    temp.Add(kv);
                }
            }
            return temp;
        }

        private void savelayout(string HtmlStr, string formName)
        {
            //解析Ajax传递HTML数据，得到控件及对应字段名称
            Document doc = NSoup.NSoupClient.Parse(HtmlStr);
            Elements inputs = doc.GetElementsByTag("input");
            Elements selects = doc.GetElementsByTag("select");
            Elements textareas = doc.GetElementsByTag("textarea");
            List<Elements> elist = new List<Elements>();
            elist.Add(inputs);
            elist.Add(selects);
            elist.Add(textareas);
            List<TableModel> list = new List<TableModel>();
            list = GetTableColumn(elist);

            //创建表单表及表单对应的表
            try
            {
                if (list != null)
                {
                    CreateForm(formName, HtmlStr, list);
                    result = "保存成功";
                }
                else
                {
                    result = "请完整设置参数";
                }
            }
            catch (Exception ex)
            {
                result = ex.Message;
            }
        }



        private void CreateForm(string formName, string HtmlStr, List<TableModel> list)
        {
            BLL.LayOutForm bll = new BLL.LayOutForm();
            bll.insert(formName, HtmlStr, list); //插入一条表单模板数据 

        }

        private List<TableModel> GetTableColumn(List<Elements> elelist)
        {
            List<TableModel> list = new List<TableModel>();
            foreach (var eitem in elelist)
            {
                foreach (var item in eitem)
                {

                    TableModel model = new TableModel();
                    model.colName = item.Attributes["name"];
                    string kjtype = string.IsNullOrEmpty(item.Attributes["type"]) ? item.NodeName : item.Attributes["type"];
                    model.coltype = kjtype;
                    model.fieldName = item.Attributes["value"];// GetFiledName(item, kjtype);
                    if ((!string.IsNullOrEmpty(model.colName)) && (!string.IsNullOrEmpty(model.fieldName)) && (item.Attributes["data-option"] != "ly"))
                    {
                        list.Add(model);
                    }

                }
            }
            return list;
        }

        private string GetFiledName(Element item, string kjtype)
        {
            if (kjtype.Trim() == "textarea")
            {
                return
                    item.SiblingElements.Text;
            }
            else if (kjtype.Trim() == "select")
            {
                return item.Children.First.Text(); //返回第一项
            }
            else if (kjtype.Trim() == "text")
            {
                return item.Attributes["value"];
            }
            else if (kjtype.Trim() == "checkbox")
            {
                return item.Attributes["value"];  //待改进 采用checkbox组进行选择操作
            }
            else if (kjtype.Trim() == "radio")
            {
                return item.Attributes["value"];
            }
            else
            {
                return "";
            }


        }



        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
    public class formControl
    {
        //name: $name, field: $field, required: $remark, remark: $remark, sort: $sort, html: $cntrhtml 
        public string name { get; set; }
        public string field { get; set; }
        public string required { get; set; }
        public string remark { get; set; }
        public int sort { get; set; }
        public string html { get; set; }
    }

    public class dataModel
    {
        public string field { get; set; }
        public string value { get; set; }
    }
}