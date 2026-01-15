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
    Class1 cl3 = new Class1();
    public static TimeZoneInfo timeZoneInfo = TimeZoneInfo.FindSystemTimeZoneById("India Standard Time");
    public static DateTime dateTime;

    protected void Page_Load(object sender, EventArgs e)
    {
        dateTime = TimeZoneInfo.ConvertTime(DateTime.Now, timeZoneInfo);
        Response.Cache.SetCacheability(HttpCacheability.NoCache);
        Response.Cache.SetNoStore();
        Response.Cache.SetExpires(DateTime.UtcNow.AddMinutes(-1));
        if (!IsPostBack)
        {
            HttpCookie lgdcookie = Request.Cookies["loggeduser"];
            if (lgdcookie != null && !string.IsNullOrEmpty(lgdcookie["username"]))
            {
                if (lgdcookie["type"] == "User")
                {
                    Response.Redirect("Dashboard.aspx");
                }
            }
        }
    }

    protected void btnLogin_Click(object sender, EventArgs e)
    {
        try
        {
            if (txtEmail.Text == "")
            {
                string message = "Please Enter Username !!";
                string type = "warning";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Script", "savealert('" + message + "','" + type + "')", true);
                return;
            }
            else if (txtPassword.Text == "")
            {
                string message = "Please Enter Password !!";
                string type = "warning";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Script", "savealert('" + message + "','" + type + "')", true);
                return;
            }
            string query = "select userid,password,name,type from UserLogin where userid='" + txtEmail.Text + "' and password='" + txtPassword.Text + "'";
            SqlDataAdapter sda = new SqlDataAdapter(query, cl3.con);
            DataTable dt = new DataTable();
            sda.Fill(dt);
            if (dt.Rows.Count > 0)
            {
                HttpCookie lgdcookie = new HttpCookie("loggeduser");
                lgdcookie["username"] = dt.Rows[0]["username"].ToString();
                lgdcookie["name"] = dt.Rows[0]["name"].ToString();
                lgdcookie["type"] = dt.Rows[0]["type"].ToString();
                lgdcookie["finyear"] = "2025-26";
                lgdcookie.Expires = DateTime.Now.AddHours(20);
                //lgdcookie.Expires = DateTime.Now.AddDays(1);
                if (lgdcookie["type"].ToString() == "Billing")
                {
                    Response.Cookies.Add(lgdcookie);
                    string message = "Your Login is not Exist !!";
                    string type = "error";
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Script", "savealert('" + message + "','" + type + "')", true);
                    return;
                    //string redirectUrl = "Dashboard.aspx";
                    //string message = "Login Successfully !!";
                    //string type = "success";
                    //string script = "savealert('" + message + "', '" + type + "'); setTimeout(function() {{ window.location.href = '" + redirectUrl + "'; }}, 0.5000);"; ScriptManager.RegisterStartupScript(this, this.GetType(), "Script", script, true);
                    //return;
                }
                else if (lgdcookie["type"].ToString() == "Store")
                {
                    Response.Cookies.Add(lgdcookie);
                    string redirectUrl = "StoreDashboard.aspx";
                    string message = "Login Successfully !!";
                    string type = "success";
                    string script = "savealert('" + message + "', '" + type + "'); setTimeout(function() {{ window.location.href = '" + redirectUrl + "'; }}, 1000);"; ScriptManager.RegisterStartupScript(this, this.GetType(), "Script", script, true);
                    return;
                }
                else if (lgdcookie["type"].ToString() == "Admin")
                {
                    Response.Cookies.Add(lgdcookie);
                    string redirectUrl = "Admin/Dashboard.aspx";
                    string message = "Login Successfully !!";
                    string type = "success";
                    string script = "savealert('" + message + "', '" + type + "'); setTimeout(function() {{ window.location.href = '" + redirectUrl + "'; }}, 1000);"; ScriptManager.RegisterStartupScript(this, this.GetType(), "Script", script, true);
                    return;
                }
                else
                {
                    txtPassword.Text = "";
                    txtEmail.Text = "";
                    string message = "Your Login is not Exist !!";
                    string type = "error";
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Script", "savealert('" + message + "','" + type + "')", true);
                    return;
                }
            }
            else
            {
                txtPassword.Text = "";
                string message = "Invalid Login Credentiala !!";
                string type = "error";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Script", "savealert('" + message + "','" + type + "')", true);
                return;
            }
        }
        catch (Exception ex)
        {
            string message = "Error: " + ex.Message + "\nStackTrace: " + ex.StackTrace;
            string type = "warning";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Script", "savealert('" + message + "','" + type + "')", true);
            return;
        }
    }

    protected void btnRegister_Click(object sender, EventArgs e)
    {
        try
        {
            if(txtName.Text =="" || txtRegEmail.Text=="" || txtMobile.Text=="" || txtRegPassword.Text==""||txtDob.Text=="")
            {
                string message = "Please Fill All Field !!";
                string type = "warning";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Script", "savealert('" + message + "','" + type + "')", true);
                return;
            }
            else
            {
                string query = "insert into UserLogin(userid,password,mobile,name,dob,insdate,instime,finyear) values('"+txtRegEmail.Text+"','"+txtPassword.Text+"','"+txtMobile.Text+"','"+txtName.Text+"','"+txtDob.Text+"','"+dateTime.ToString("yyyy-MM-dd")+"','"+dateTime.ToString("hh:mm:ss tt")+"','2026-2027')";
                SqlCommand cmd = new SqlCommand(query,cl3.con);
                cl3.con.Open();
                int n=cmd.ExecuteNonQuery();
                cl3.con.Close();
                if(n>0)
                {
                    string message = "Registration Successfully Done !!";
                    string type = "success";
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Script", "savealert('" + message + "','" + type + "')", true);
                    return;
                }
            }
        }
        catch (Exception ex)
        {
            string message = "Something Went Wrong !!";
            string type = "error";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Script", "savealert('" + message + "','" + type + "')", true);
            return;
        }
    }
}