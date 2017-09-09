using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BLL;
using System.Data;
using System.IO;
using System.Text;
using NSoup.Nodes;
using NSoup.Select;

namespace GYLYEQ.AppSupport.layout
{
    public partial class DynamicForm : System.Web.UI.Page
    {
        LayOutForm bll = new LayOutForm();
        public string HTML;
        public string fid = "";
        public string url = "#";
        protected void Page_Load(object sender, EventArgs e)
        {
            fid = Request.QueryString["ID"].ToString();
            url = Request.QueryString["url"].ToString();
            if (!IsPostBack)
            {

            }
            BindHTML();
        }

        private void BindHTML()
        {

            if (string.IsNullOrEmpty(fid))
            {
                HTML = "暂无表单模板";
                return;
            }
            if (File.Exists(Server.MapPath(fid + ".txt")))
            {
                string SOURCEHTML = File.ReadAllText(Server.MapPath(fid + ".txt"), Encoding.UTF8);
                Document doc = NSoup.NSoupClient.Parse(SOURCEHTML);
                Elements selectHTML = doc.GetElementsByClass("view");
                HTML = selectHTML[1].ToString();
            }
        }


        protected void DropDownList1_SelectedIndexChanged(object sender, EventArgs e)
        {

        }
    }
}