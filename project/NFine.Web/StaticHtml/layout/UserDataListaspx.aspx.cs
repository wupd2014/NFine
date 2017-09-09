using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;
using System.Data;
using System.Text;

namespace GYLYEQ.AppSupport.layout
{
    public partial class UserDataListaspx : System.Web.UI.Page
    {
        LayOutForm bll = new LayOutForm();
        public string colstr = string.Empty;
        public string layoutid = string.Empty;
        protected void Page_Load(object sender, EventArgs e)
        {
            layoutid = Request.QueryString["layoutid"];
            if (!IsPostBack)
            {
                BindDDLInfo();
                GetJsonData(layoutid);
            }
           
        }

        private void BindDDLInfo()
        {
            DataTable dt1 = bll.GetDataTable("FORMLAYOUT", "");
            ddlform.DataSource = dt1;
            ddlform.DataTextField = "NAME";
            ddlform.DataValueField = "ID";
            ddlform.DataBind();
            if (string.IsNullOrEmpty(layoutid)) {
                layoutid = ddlform.SelectedValue;
            }
            DataTable dt = bll.GetDataTable("FORMLAYOUTFIELDZD", "FRMLAYID=" + layoutid);
            ddlField.DataSource = dt;
            ddlField.DataTextField = "FILEDNAME";
            ddlField.DataValueField = "FILED";
            ddlField.DataBind();
        }
        protected void DropDownList1_SelectedIndexChanged(object sender, EventArgs e)
        {
            layoutid = ddlform.SelectedValue;
            DataTable dt = bll.GetDataTable("FORMLAYOUTFIELDZD", "FRMLAYID=" + layoutid);
            ddlField.DataSource = dt;
            ddlField.DataTextField = "FILEDNAME";
            ddlField.DataValueField = "FILED";
            ddlField.DataBind();
            GetJsonData(layoutid);
        }
        private void GetJsonData(string layoutid)
        {
            DataTable dtcols = bll.GetDataTable("FORMLAYOUTFIELDZD", "FRMLAYID=" + layoutid);
            if (dtcols != null)
            {
                colstr = productColsJsonData(dtcols);
            }
        }

        private string productColsJsonData(DataTable dtcols)
        {
            StringBuilder sb = new StringBuilder();

            if (dtcols.Rows.Count > 0)
            {
                sb.Append("[");
                for (int i = 0; i < dtcols.Rows.Count; i++)
                {
                    //sb.Append("{");
                    //{ title:'股票代码', name:'SECUCODE' ,width:100, align:'center' },
                    string tmp = "";
                    if (i < 25)
                    {
                        tmp = "{ " + string.Format("\"title\":\"{0}\", \"name\":\"{1}\" , \"align\":\"center\",\"sortable\": true", dtcols.Rows[i][3], dtcols.Rows[i][2].ToString().ToLower()) + "},";
                    }
                    else
                    {
                        tmp = "{ " + string.Format("\"title\":\"{0}\", \"name\":\"{1}\" , \"align\":\"center\",\"sortable\": true", dtcols.Rows[i][3], dtcols.Rows[i][2].ToString().ToLower()) + "},";
                    }
                    sb.Append(tmp);
                    //sb.Append("}");
                }
                sb.Remove(sb.Length - 1, 1);
                sb.Append("]");
            }
            else
            {
                sb.Append("[ ]");
            }
            return sb.ToString();
        }

    }
}