using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;
using Wuqi.Webdiyer;
using BLL;
using GYLYEQ.BLL;
using GYLYEQ.DBUtility;
using System.Web.Services;

namespace GYLYEQ.AppSupport.layout
{
    public partial class DataList : System.Web.UI.Page
    {
        FORM_BUILDER_CONTROL cntrBll = new FORM_BUILDER_CONTROL();
        FORM_BUILDER_FORM frmBll = new FORM_BUILDER_FORM();
        public string html = "";
        public string formID = "";
        public string frmName = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                formID = Request.QueryString["formID"];
                this.hidformID.Value = formID;
                BindInfoData();
            }
        }

        private void BindInfoData()
        {
            //try
            //{
            DataTable dt = cntrBll.GetList(" formid=" + formID + " order by CONTROLSORT asc").Tables[0];
            string tableName = frmBll.GetModel(decimal.Parse(formID)).FORMTABLE;
            frmName = frmBll.GetModel(decimal.Parse(formID)).FORMNAME;
            List<string> SelectColsList = new List<string>();
            List<string> SelectColsName = new List<string>();
            StringBuilder TableHtml = new StringBuilder();
            TableHtml.Append("<tr>");
            foreach (DataRow item in dt.Rows)
            {
                SelectColsList.Add("t." + item["CONTROLFIELD"].ToString());
                TableHtml.AppendFormat("<th>{0}</th>", item["CONTROLNAME"].ToString());
            }
            TableHtml.Append("<th>操作</th>");
            TableHtml.Append("</tr>");

            int startIndex = (AspNetPager1.CurrentPageIndex - 1) * AspNetPager1.PageSize + 1;
            int endIndex = AspNetPager1.CurrentPageIndex * AspNetPager1.PageSize;
            string sql = string.Format(" SELECT * FROM (SELECT ROWNUM AS rowno, {1},t.CONTROLID FROM {0} t WHERE ROWNUM <= {2}) table_alias WHERE table_alias.rowno >= {3} ", tableName, string.Join(",", SelectColsList), endIndex, startIndex);
            DataTable dtData = DbHelperOra.Query(sql).Tables[0];
            string counSql = string.Format("select count(*) from {0}", tableName);
            string allcount = DbHelperOra.Query(counSql).Tables[0].Rows[0][0].ToString();

            foreach (DataRow item in dtData.Rows)
            {
                TableHtml.Append("<tr  class=\"table_all_bg\">");
                foreach (string im in SelectColsList)
                {
                    TableHtml.AppendFormat("<td>{0}</td>", item[im.Replace("t.", "")].ToString());
                }
                TableHtml.Append("<td><label onclick=Del('" + item["CONTROLID"] + "') href='#'>删除</label></td>");
                TableHtml.Append("</tr>");
            }
            html = TableHtml.ToString();
            if (dt.Rows.Count > 0)
            {
                AspNetPager1.Visible = true;
                AspNetPager1.RecordCount = int.Parse(allcount);
            }
            else
            {
                AspNetPager1.Visible = true;
                AspNetPager1.RecordCount = 0;
            }
            //}
            //catch
            //{ }



        }
        protected void btnCx_Click(object sender, EventArgs e)
        {
            BindInfoData();
        }
        protected void btnAdd_Click(object sender, EventArgs e)
        {
            Response.Redirect("../layout/index.html");
        }
        protected void AspNetPager2_OnPageChanged(object src, PageChangedEventArgs e)
        {
            AspNetPager1.CurrentPageIndex = e.NewPageIndex;
            BindInfoData();
        }

        [WebMethod]
        public static string Del(string ID, string formid)
        {
            FORM_BUILDER_FORM frmstaBll = new FORM_BUILDER_FORM();
            string tableName = frmstaBll.GetModel(decimal.Parse(formid)).FORMTABLE;

            string Sqlstr = string.Format("delete from {0} where CONTROLID={1}", tableName, ID);
            try
            {
                int rows = DbHelperOra.ExecuteSql(Sqlstr);
                if (rows > 0)
                {
                    return "删除成功！";
                }
                else
                {
                    return "删除失败！";
                }
            }
            catch (Exception ex)
            {
                return ex.Message;
            }
        }
    }
}