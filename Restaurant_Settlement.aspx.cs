using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

public partial class Restaurant_Settlement : System.Web.UI.Page
{
    Class1 cl = new Class1();
    public static TimeZoneInfo timeZoneInfo = TimeZoneInfo.FindSystemTimeZoneById("India Standard Time");
    public static DateTime dateTime;
    HttpCookie lgdcookie;

    protected void Page_Load(object sender, EventArgs e)
    {
        lgdcookie = Request.Cookies["loggeduser"];
        dateTime = TimeZoneInfo.ConvertTime(DateTime.Now, timeZoneInfo);
        if (!IsPostBack)
        {
            bindata();
        }
    }
    public void bindata()
    {
        string query = "select bill_no,table_no,format(bill_date,'dd/MM/yyyy') as bill_date,grandtotal from bill_master where IsPaid = 0 order by bill_no";
        SqlDataAdapter sda = new SqlDataAdapter(query, cl.con);
        DataTable dt = new DataTable();
        sda.Fill(dt);
        if (dt.Rows.Count > 0)
        {
            gridview1.DataSource = dt;
            gridview1.DataBind();
            panel1.Visible = true;
            panel2.Visible = false;
        }
        else
        {
            string redirectUrl = "dashboard.aspx";
            string message = "Data not Found !!";
            string type = "error";
            string script = "savealert('" + message + "','" + type + "'); setTimeout(function() { window.location.href = '" + redirectUrl + "'; },1000);";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Script", script, true);
            return;
        }
    }
    protected void btnsettel_Click(object sender, EventArgs e)
    {
        try
        {
            LinkButton button1 = (LinkButton)sender;
            GridViewRow row = (GridViewRow)button1.Parent.Parent;
            Label billk = ((Label)row.FindControl("lblbill") as Label);
            lblbillno.Text = billk.Text;
            Label tab = ((Label)row.FindControl("lbltable") as Label);
            lbltableno.Text = tab.Text;
            Label amt = ((Label)row.FindControl("lblamt") as Label);
            lbltamt.Text = amt.Text;
            panel1.Visible = false;
            panel2.Visible = true;
        }
        catch (Exception ex)
        {

        }

    }
    protected void btnback_Click(object sender, EventArgs e)
    {
        Response.Redirect("dashboard.aspx");
    }
    protected void btnsettle_Click(object sender, EventArgs e)
    {
        string mode = "";
        try
        {
            if (rbtnpaymode.SelectedValue == "0")
            {
                mode = "Cash";
            }
            else if (rbtnpaymode.SelectedValue == "1")
            {
                mode = "Credit Card";
            }
            else
            {
                string message1 = "Please Select Payment Mode !!";
                string type1 = "warning";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Script", "savealert('" + message1 + "','" + type1 + "')", true);
                return;
            }
            cl.con.Open();
            SqlCommand cmd = new SqlCommand();
            cmd.Connection = cl.con;
            cmd.CommandText = "update bill_master set paymentmode = @paymentmode, ispaid = 1,upduser = @upduser ,upddate = @upddate ,updtime =@updtime where bill_no = @bill and table_no = @table";
            cmd.Parameters.AddWithValue("@bill", lblbillno.Text);
            cmd.Parameters.AddWithValue("@table", lbltableno.Text);
            cmd.Parameters.AddWithValue("@paymentmode", mode);
            cmd.Parameters.AddWithValue("@upduser", lgdcookie["UserName"].ToString());
            cmd.Parameters.AddWithValue("@upddate", dateTime.ToString("yyyy-MM-dd"));
            cmd.Parameters.AddWithValue("@updtime", dateTime.ToString("hh:mm:ss tt"));
            cmd.ExecuteNonQuery();
            cl.con.Close();
           // Response.Write("<script language='javascript'>window.alert('Payment Settle Successfully!!');window.location=('Restaurant_Settlement.aspx');</script>");
            panel1.Visible = true;
            panel2.Visible = false;
            string redirectUrl = "Restaurant_Settlement.aspx";
            string message = "Payment Settled Successfully !!";
            string type = "success";
            string script = "savealert('" + message + "','" + type + "'); setTimeout(function() { window.location.href = '" + redirectUrl + "'; },1000);";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Script", script, true);
            return;
        }
        catch (Exception ex)
        {

        }
    }
}