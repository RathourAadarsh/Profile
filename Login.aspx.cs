using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

public partial class Login : System.Web.UI.Page
{
    public static TimeZoneInfo timeZoneInfo = TimeZoneInfo.FindSystemTimeZoneById("GMT Standard Time");
    public static DateTime dateTime;
    Class1 cl = new Class1();

    protected void Page_Load(object sender, EventArgs e)
    {
        dateTime = TimeZoneInfo.ConvertTime(DateTime.Now, timeZoneInfo);
        Response.Cache.SetCacheability(HttpCacheability.NoCache);
        Response.Cache.SetNoStore();
        Response.Cache.SetExpires(DateTime.UtcNow.AddMinutes(-1));
        if (!IsPostBack)
        {
            HttpCookie logincookie = Request.Cookies["userauth"];
            if (Request.Cookies["userauth"] != null)
            {
                HttpCookie userAuthCookie = new HttpCookie("userauth");
                userAuthCookie.Expires = DateTime.Now.AddDays(-1);
                Response.Cookies.Add(userAuthCookie);
            }
            bindfinyear();
        }
    }

    protected void btnLogin_Click(object sender, EventArgs e)
    {
        try
        {
            if (txtuserid.Text == "")
            {
                string message = "Please Enter Username !!";
                string type = "warning";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Script", "savealert('" + message + "','" + type + "')", true);
                return;
            }
            else if (txtpassword.Text == "")
            {
                string message = "Please Enter Password !!";
                string type = "warning";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Script", "savealert('" + message + "','" + type + "')", true);
                return;
            }
            else
            {
                string query = "select name,username,password,type from Login where username='" + txtuserid.Text + "' and password='" + txtpassword.Text + "' and isActive='0'";
                SqlDataAdapter sda = new SqlDataAdapter(query, cl.con);
                DataTable dt = new DataTable();
                sda.Fill(dt);
                if (dt.Rows.Count > 0)
                {
                    loginsms.InnerText = "You have logged Successfully !!";
                    string usertype = dt.Rows[0]["type"].ToString();
                    HttpCookie logincookie = new HttpCookie("userauth");
                    logincookie["name"] = dt.Rows[0]["name"].ToString();
                    logincookie["username"] = txtuserid.Text;
                    logincookie["finyear"] = ddlfinyear.SelectedValue;
                    logincookie["type"] = usertype;
                    logincookie.Expires = DateTime.Now.AddYears(1);
                    if (usertype == "Admin")
                    {
                        Response.Cookies.Add(logincookie);
                        Response.Redirect("Dashboard.aspx");
                        return;
                    }
                }
                else
                {
                    string query1 = "select ac_code,ac_name as name,mobile as username,ac_code,'User' as type from partyMaster where mobile='" + txtuserid.Text + "' and ac_code='" + txtpassword.Text + "'";
                    SqlDataAdapter sda1 = new SqlDataAdapter(query1, cl.con);
                    DataTable dt1 = new DataTable();
                    sda1.Fill(dt1);
                    if (dt1.Rows.Count > 0)
                    {
                        string usertype = dt1.Rows[0]["type"].ToString();
                        HttpCookie logincookie = new HttpCookie("userauth");
                        logincookie["name"] = dt1.Rows[0]["name"].ToString();
                        logincookie["ac_code"] = dt1.Rows[0]["ac_code"].ToString();
                        logincookie["username"] = txtuserid.Text;
                        logincookie["finyear"] = ddlfinyear.SelectedValue;
                        logincookie["type"] = usertype;
                        logincookie.Expires = DateTime.Now.AddYears(1);
                            Response.Cookies.Add(logincookie);
                            Response.Redirect("User/Dashboard.aspx");
                            return;
                    }
                    else
                    {
                        string message = "Invalid Login Credentials !!";
                        string type = "error";
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "Script", "savealert('" + message + "','" + type + "')", true);
                        return;
                    }
                }
               
            }
        }
        catch (Exception ex)
        {

        }
    }
    public void bindfinyear()
    {
        try
        {
            string query = @"DECLARE @today DATE = GETDATE();
            DECLARE @year INT;
            IF MONTH(@today) >= 4
                SET @year = YEAR(@today);
            ELSE
                SET @year = YEAR(@today) - 1;
            SELECT CAST(@year AS VARCHAR) +'-' + RIGHT(CAST(@year + 1 AS VARCHAR), 2) AS FinancialYear";

            SqlDataAdapter da = new SqlDataAdapter(query, cl.con);
            DataTable dt = new DataTable();
            da.Fill(dt);
            if (dt.Rows.Count > 0)
            {
                ddlfinyear.DataSource = dt;
                ddlfinyear.DataTextField = "FinancialYear";
                ddlfinyear.DataValueField = "FinancialYear";
                ddlfinyear.DataBind();
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine(ex.Message);
        }
    }
}