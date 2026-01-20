using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.IO;

public partial class Restaurant_Billing : System.Web.UI.Page
{
    Class1 cl = new Class1();
    public static TimeZoneInfo timeZoneInfo = TimeZoneInfo.FindSystemTimeZoneById("India Standard Time");
    public static DateTime dateTime;
    protected void Page_Load(object sender, EventArgs e)
    {
        dateTime = TimeZoneInfo.ConvertTime(DateTime.Now, timeZoneInfo);
        if (!IsPostBack)
        {
            if (Request.QueryString["billno"] != null &&
                Request.QueryString["tableno"] != null)
            {
                lblbillno.Text = Request.QueryString["billno"];
                lbltable.Text = Request.QueryString["tableno"];                
                bindbill();
            }
        }

    }
    protected void btncancel_Click(object sender, EventArgs e)
    {
        Response.Redirect("Dashboard.aspx");
    }
    protected void btnPrint_Click(object sender, EventArgs e)
    {
        bill.Visible = true;      
        bindbill();               

        ScriptManager.RegisterStartupScript(
            this,
            this.GetType(),
            "Print",
            "window.print();",
            true
        );
    }

    public void bindbill()
    {
        try
        {
            Label6.Text = lblbillno.Text;
            //Label10.Text = lbltable.Text;
            string query = "select itemname,rate,qty,amount,convert(nvarchar,bill_date,103)insdate,bill_no,grandtotal,tax,Discount,subtotal from Bill_Master bm left join Bill_Detail bd on bm.bill_id = bd.bill_id where isrunning = 1 and bill_no='" + lblbillno.Text + "' and table_no='" + lbltable.Text + "'";
            SqlDataAdapter sda = new SqlDataAdapter(query, cl.con);
            DataTable dt = new DataTable();
            sda.Fill(dt);
            if (dt.Rows.Count > 0)
            {
                gridbill.DataSource = dt;
                gridbill.DataBind();
                lblbilldate.Text = dt.Rows[0]["insdate"].ToString();
                lbldate.Text = dt.Rows[0]["insdate"].ToString();
                lblptotal.Text = dt.Rows[0]["subtotal"].ToString();
                lblsuttotal.Text = dt.Rows[0]["subtotal"].ToString();
                lbldiscount.Text = dt.Rows[0]["Discount"].ToString();
                lbldisamount.Text = dt.Rows[0]["Discount"].ToString();
                Label17.Text = dt.Rows[0]["tax"].ToString();
                txtgst.Text = dt.Rows[0]["tax"].ToString();
                Label18.Text = dt.Rows[0]["grandtotal"].ToString();
                lblgtotal.Text = dt.Rows[0]["grandtotal"].ToString();                 
            }
        }
        catch (Exception ex)
        {

        }
    }

    protected void gridbill_RowDataBound(object sender, GridViewRowEventArgs e)
    {

        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            Label lblDisc = (Label)e.Row.FindControl("lbldisc");

            if (lblDisc != null && (lblDisc.Text == "0" || lblDisc.Text == "0.00"))
            {
                lblDisc.Visible = false;
            }
        }
    }

}

