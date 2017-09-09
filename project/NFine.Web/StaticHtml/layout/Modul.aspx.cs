using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using GYLYEQ.BLL;

namespace GYLYEQ.AppSupport.layout
{
    public partial class Modul : System.Web.UI.Page
    {
        FORM_BUILDER_FORM frmBll = new FORM_BUILDER_FORM();
        FORM_BUILDER_CONTROL cntrBll = new FORM_BUILDER_CONTROL();
        public string formID;
        public string columns;
        public string formName;
        protected void Page_Load(object sender, EventArgs e)
        {

            if (!IsPostBack)
            {
                formID = Request.QueryString["formID"];
                columns = Request.QueryString["columns"];
                formName = frmBll.GetModel(decimal.Parse(formID)).FORMNAME;
                BindRepeater(formID, columns);
            }
        }

        //表单ID，表单布局列数
        private void BindRepeater(string formID, string columns)
        {
            if (columns == "2")
            {//二列情况
                oddRepeater.DataSource = cntrBll.GetList(" mod(controlsort,2)=1 and FORMID= " + formID + " order by CONTROLSORT asc");
                oddRepeater.DataBind();

                evenRepeater.DataSource = cntrBll.GetList(" mod(controlsort,2)=0 and FORMID= " + formID + " order by CONTROLSORT asc");
                evenRepeater.DataBind();

                OneColumnDiv.Style["display"] = "none";
                TwoColDiv_1.Style["display"] = "block";
                TwoColDiv_2.Style["display"] = "block";
            }
            else
            {
                //一列情况
                OneColumnRepeater.DataSource = cntrBll.GetList(" FORMID= " + formID + " order by CONTROLSORT asc");
                OneColumnRepeater.DataBind();

                OneColumnDiv.Style["display"] = "block";
                TwoColDiv_1.Style["display"] = "none";
                TwoColDiv_2.Style["display"] = "none";
            }
        }
    }
}