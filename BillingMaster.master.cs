using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class BillingMaster : System.Web.UI.MasterPage
{
    public static TimeZoneInfo timeZoneInfo = TimeZoneInfo.FindSystemTimeZoneById("India Standard Time");
    public static DateTime dateTime;
    Class1 cl3 = new Class1();
    HttpCookie lgdcookie;
    protected void Page_Load(object sender, EventArgs e)
    {
        lgdcookie = Request.Cookies["loggeduser"];
        if (lgdcookie != null && !string.IsNullOrEmpty(lgdcookie["UserName"]))
        {
            if (!IsPostBack)
            {
                lblUserName.Text = lgdcookie["name"].ToString();
                dateTime = TimeZoneInfo.ConvertTime(DateTime.Now, timeZoneInfo);
            }
        }
        else
        {
            Response.Redirect("Login.aspx");
        }
    }
    protected void btnlogou_Click(object sender, EventArgs e)
    {
        try
        {
            Session.Clear();
            Session.Abandon();
            HttpCookie lgdcookie = new HttpCookie("loggeduser");
            lgdcookie.Expires = DateTime.Now.AddDays(-1);
            Response.Cookies.Add(lgdcookie);
            Response.Redirect("Login.aspx");
        }
        catch (Exception ex)
        {

        }
    }
}
