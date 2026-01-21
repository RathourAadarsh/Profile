using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Billing : System.Web.UI.Page
{
    public static TimeZoneInfo timeZoneInfo = TimeZoneInfo.FindSystemTimeZoneById("India Standard Time");
    public static DateTime dateTime;
    HttpCookie lgdcookie;

    Class1 cl = new Class1();
    public static string sku = "";
    public static string kotbill = "";
    protected string TableNo = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        lgdcookie = Request.Cookies["loggeduser"];
        if (lgdcookie != null && !string.IsNullOrEmpty(lgdcookie["UserName"]))
        {
            dateTime = TimeZoneInfo.ConvertTime(DateTime.Now, timeZoneInfo);
            if (!IsPostBack)
            {
                if (string.IsNullOrWhiteSpace(Request.QueryString["table_no"]))
                {
                    Response.Redirect("Dashboard.aspx");
                    return;
                }
                hfTableNo.Value = Request.QueryString["table_no"];
                lblTableNo.Text = hfTableNo.Value;
                LoadOpenKOT(hfTableNo.Value);
                itemgroup();
                CalculateBill();
                GenerateBill();
            }
        }
        else
        {
            Response.Redirect("Login.aspx");
        }
    }
    private void LoadOpenKOT(string tableNo)
    {
        DataTable dt = new DataTable();
        dt.Columns.Add("ItemName");
        dt.Columns.Add("Rate", typeof(decimal));
        dt.Columns.Add("Qty", typeof(int));
        dt.Columns.Add("Amount", typeof(decimal));
        dt.Columns.Add("Flag", typeof(int));
        dt.Columns.Add("SKU", typeof(string));
        dt.Columns.Add("GST", typeof(decimal));

        SqlCommand cmd = new SqlCommand("SELECT d.ItemName, d.Rate, d.Qty, d.Amount, ISNULL(i.flag,1) Flag,d.sku,d.gst_per FROM KOT_Master m INNER JOIN KOT_Detail d ON m.KOT_ID = d.KOT_ID LEFT JOIN item_detail i ON d.ItemName = i.item_name WHERE m.Table_No = @TableNo AND m.IsClosed = 0 ", cl.con);

        cmd.Parameters.AddWithValue("@TableNo", tableNo);

        cl.con.Open();
        SqlDataReader dr = cmd.ExecuteReader();
        while (dr.Read())
        {
            DataRow r = dt.NewRow();
            r["ItemName"] = dr["ItemName"];
            r["Rate"] = dr["Rate"];
            r["Qty"] = dr["Qty"];
            r["Amount"] = dr["Amount"];
            r["Flag"] = dr["Flag"];
            r["SKU"] = dr["sku"];
            r["GST"] = dr["gst_per"];

            dt.Rows.Add(r);
        }
        cl.con.Close();

        Session["BillTable"] = dt;
        gvBill.DataSource = dt;
        gvBill.DataBind();
    }
    public void itemgroup()
    {
        string query = "select item_g_id, item_g_name from Item_group_master order by item_g_name";
        SqlDataAdapter sda = new SqlDataAdapter(query, cl.con);
        DataTable dt = new DataTable();
        sda.Fill(dt);
        if (dt.Rows.Count > 0)
        {
            lst.DataSource = dt;
            lst.DataBind();
        }
    }

    protected void lnlroom_Click(object sender, EventArgs e)
    {
        LinkButton btn = (LinkButton)sender;
        ListViewDataItem dataItem = (ListViewDataItem)btn.NamingContainer;

        int groupId = Convert.ToInt32(lst.DataKeys[dataItem.DataItemIndex].Value);

        string query2 = "select item_name from item_detail where item_group_name = @gid";

        SqlDataAdapter sda = new SqlDataAdapter(query2, cl.con);
        sda.SelectCommand.Parameters.AddWithValue("@gid", groupId);

        DataTable dt = new DataTable();
        sda.Fill(dt);

        if (dt.Rows.Count > 0)
        {
            ListView1.DataSource = dt;
            ListView1.DataBind();
            Panel1.Visible = true;
            lblmessage.Visible = false;
        }
        else
        {
            lblmessage.Text = "Item Not Found!!";
            lblmessage.Visible = true;
            Panel1.Visible = false;
        }
    }

    protected void itemname_Click(object sender, EventArgs e)
    {
        LinkButton btn = (LinkButton)sender;
        string itemName = btn.Text;

        string query = "SELECT item_sale_rate, flag,sku, gst_per FROM item_detail WHERE item_name=@name";
        SqlCommand cmd = new SqlCommand(query, cl.con);
        cmd.Parameters.AddWithValue("@name", itemName);

        decimal rate = 0;
        int flag = 1;
        string sku = "";
        decimal gst = 0;

        cl.con.Open();
        SqlDataReader dr = cmd.ExecuteReader();
        if (dr.Read())
        {
            rate = Convert.ToDecimal(dr["item_sale_rate"]);
            flag = Convert.ToInt32(dr["flag"]);
            sku = dr["sku"].ToString();
            gst = dr["gst_per"] == DBNull.Value ? 0 : Convert.ToDecimal(dr["gst_per"]);
        }
        cl.con.Close();
        DataTable dt;
        if (Session["BillTable"] == null)
        {
            dt = new DataTable();
            dt.Columns.Add("ItemName", typeof(string));
            dt.Columns.Add("Rate", typeof(decimal));
            dt.Columns.Add("Qty", typeof(int));
            dt.Columns.Add("Amount", typeof(decimal));
            dt.Columns.Add("Flag", typeof(int));
            dt.Columns.Add("SKU", typeof(string));
            dt.Columns.Add("GST", typeof(decimal));
            Session["BillTable"] = dt;
        }
        else
        {
            dt = (DataTable)Session["BillTable"];
        }        

        DataRow row = dt.AsEnumerable()
            .FirstOrDefault(r => r.Field<string>("ItemName") == itemName);

        if (row != null)
        {
            row["Qty"] = Convert.ToInt32(row["Qty"]) + 1;
            row["Amount"] = Convert.ToInt32(row["Qty"]) * rate;
        }
        else
        {
            DataRow drNew = dt.NewRow();
            drNew["ItemName"] = itemName;
            drNew["Rate"] = rate;
            drNew["Qty"] = 1;
            drNew["Amount"] = rate;
            drNew["Flag"] = flag;
            drNew["SKU"] = sku;
            drNew["GST"] = gst;
            dt.Rows.Add(drNew);
        }

        Session["BillTable"] = dt;
        gvBill.DataSource = dt;
        gvBill.DataBind();
        CalculateBill();
    }
    protected void gvBill_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (Session["BillTable"] == null) return;

        DataTable dt = (DataTable)Session["BillTable"];

        int index;
        if (!int.TryParse(e.CommandArgument.ToString(), out index))
            return;

        if (index < 0 || index >= dt.Rows.Count)
            return;

        if (e.CommandName == "Plus")
        {
            dt.Rows[index]["Qty"] =
                Convert.ToInt32(dt.Rows[index]["Qty"]) + 1;
        }
        else if (e.CommandName == "Minus")
        {
            int q = Convert.ToInt32(dt.Rows[index]["Qty"]);

            if (q > 1)
                dt.Rows[index]["Qty"] = q - 1;
            else
                dt.Rows.RemoveAt(index);
        }
        else if (e.CommandName == "Remove")
        {
            dt.Rows.RemoveAt(index);
        }
        foreach (DataRow r in dt.Rows)
        {
            r["Amount"] =
                Convert.ToDecimal(r["Rate"]) * Convert.ToInt32(r["Qty"]);
        }
        Session["BillTable"] = dt;
        gvBill.DataSource = dt;
        gvBill.DataBind();
        CalculateBill();
    }
    private void CalculateBill()
    {
        if (Session["BillTable"] == null) return;

        DataTable dt = (DataTable)Session["BillTable"];

        decimal subTotal = 0;
        decimal tax = 0;

        foreach (DataRow row in dt.Rows)
        {
            decimal amt = Convert.ToDecimal(row["Amount"]);
            decimal gstPer = row["GST"] == DBNull.Value ? 0 : Convert.ToDecimal(row["GST"]);

            // Sub Total
            subTotal += amt;

            // Item wise GST
            tax += Math.Round((amt * gstPer) / 100, 2);
        }

        // Discount
        decimal discount = 0;
        decimal.TryParse(txtdiscount.Text, out discount);
        if (discount > subTotal)
            discount = subTotal;

        decimal netAmount = subTotal - discount;

        // Delivery Charge
        decimal deliveryCharge = 0;
        decimal.TryParse(txtdilivery.Text, out deliveryCharge);

        // Grand Total
        decimal exactTotal = netAmount + tax + deliveryCharge;
        decimal grandTotal = Math.Round(exactTotal);
        decimal roundOff = grandTotal - exactTotal;

        // UI
        lblSubTotal.Text = subTotal.ToString("0.00");
        lblTax.Text = tax.ToString("0.00");
        lblRoundOff.Text = roundOff.ToString("0.00");
        lblGrandTotal.Text = grandTotal.ToString("0.00");

        CalculateReturn(grandTotal);
    }

    protected void txtdilivery_TextChanged(object sender, EventArgs e)
    {
        CalculateBill();
    }
    protected void txtdiscount_TextChanged(object sender, EventArgs e)
    {
        CalculateBill();
    }

    private void CalculateReturn(decimal grandTotal)
    {
        decimal paid = 0;
        decimal.TryParse(txtCustomerPaid.Text, out paid);

        decimal ret = paid - grandTotal;
        if (ret < 0) ret = 0;

        lblReturn.Text = ret.ToString("0.00");
    }
    protected void txtCustomerPaid_TextChanged(object sender, EventArgs e)
    {
        decimal grandTotal = Convert.ToDecimal(lblGrandTotal.Text);
        CalculateReturn(grandTotal);
    }
    protected void txtnumber_TextChanged(object sender, EventArgs e)
    {
        string search = txtnumber.Text.Trim();

        if (string.IsNullOrEmpty(search))
        {
            ListView1.DataSource = null;
            ListView1.DataBind();
            return;
        }

        string query = "SELECT item_name FROM item_detail WHERE item_name LIKE @search";

        SqlDataAdapter sda = new SqlDataAdapter(query, cl.con);
        sda.SelectCommand.Parameters.AddWithValue("@search", "%" + search + "%");

        DataTable dt = new DataTable();
        sda.Fill(dt);

        if (dt.Rows.Count > 0)
        {
            ListView1.DataSource = dt;
            ListView1.DataBind();
            Panel1.Visible = true;
            lblmessage.Visible = false;
        }
        else
        {
            lblmessage.Text = "Item Not Found!";
            lblmessage.Visible = true;
            Panel1.Visible = false;
        }
    }
    protected void chkPaid_CheckedChanged(object sender, EventArgs e)
    {
        if (chkPaid.Checked)
        {
            txtCustomerPaid.Text = lblGrandTotal.Text;
            CalculateReturn(Convert.ToDecimal(lblGrandTotal.Text));
        }
    }
    protected void btnKot_Click(object sender, EventArgs e)
    {
        SaveKOT(false);
    }
    protected void btnKotPrint_Click(object sender, EventArgs e)
    {
        SaveKOT(true);
    }
    private int GetCurrentBillNo(int tableNo)
    {
        SqlCommand cmd = new SqlCommand("SELECT ISNULL(MAX(Bill_No),0) + 1 FROM KOT_Master WHERE Table_No=@t AND IsClosed=1", cl.con);

        cmd.Parameters.AddWithValue("@t", tableNo);

        cl.con.Open();
        int billNo = Convert.ToInt32(cmd.ExecuteScalar());
        cl.con.Close();

        return billNo == 0 ? 1 : billNo;
    }
    private void ClearGridAfterKOT()
    {
        DataTable dt = (DataTable)Session["BillTable"];
        dt.Clear();
        Session["BillTable"] = dt;
        gvBill.DataSource = dt;
        gvBill.DataBind();
        CalculateBill();
    }
    private void SaveKOT(bool isPrint)
    {
        if (Session["BillTable"] == null) return;
        DataTable dt = (DataTable)Session["BillTable"];
        if (dt.Rows.Count == 0) return;

        string tableNo = hfTableNo.Value;
        string kotNo = GenerateKOTNo();

        decimal kotTotal = 0;
        foreach (DataRow r in dt.Rows)
        {
            kotTotal += Convert.ToDecimal(r["Amount"]);
        }

        cl.con.Open();
        using (SqlTransaction tran = cl.con.BeginTransaction())
        {
            try
            {
                SqlCommand cmdKot = new SqlCommand("INSERT INTO KOT_Master(Table_No, KOT_No, KOT_Date, IsPrinted, IsClosed,IsRunning,KOTTime,total,Gstper,Grandtotal) OUTPUT INSERTED.KOT_ID VALUES(@TableNo, @KOTNo, GETUTCDATE(), @Printed, 0,1,@KOTTime,@total,@Gstper,@Grandtotal)", cl.con, tran);

                cmdKot.Parameters.AddWithValue("@TableNo", tableNo);
                cmdKot.Parameters.AddWithValue("@KOTNo", kotNo);
                cmdKot.Parameters.AddWithValue("@Printed", isPrint);
                cmdKot.Parameters.AddWithValue("@KOTTime", dateTime.ToString("hh:mm tt"));
                cmdKot.Parameters.AddWithValue("@total", kotTotal);
                cmdKot.Parameters.AddWithValue("@Gstper", lblTax.Text);
                cmdKot.Parameters.AddWithValue("@Grandtotal", lblGrandTotal.Text);

                int kotId = Convert.ToInt32(cmdKot.ExecuteScalar());

                foreach (DataRow r in dt.Rows)
                {
                    SqlCommand cmdItem = new SqlCommand("INSERT INTO KOT_Detail(KOT_ID, ItemName, Rate, Qty, Amount,sku,gst_per) VALUES (@KOT_ID, @Item, @Rate, @Qty, @Amount,@SKU,@gst)", cl.con, tran);

                    cmdItem.Parameters.AddWithValue("@KOT_ID", kotId);
                    cmdItem.Parameters.AddWithValue("@Item", r["ItemName"]);
                    cmdItem.Parameters.AddWithValue("@Rate", r["Rate"]);
                    cmdItem.Parameters.AddWithValue("@Qty", r["Qty"]);
                    cmdItem.Parameters.AddWithValue("@Amount", r["Amount"]);
                    cmdItem.Parameters.AddWithValue("@sku", r["SKU"]);
                    cmdItem.Parameters.AddWithValue("@gst", r["GST"]);


                    cmdItem.ExecuteNonQuery();
                }

                tran.Commit();
                dt.Clear();
            }
            catch
            {
                try { tran.Rollback(); } catch { }
                throw;
            }
        }
        if (isPrint)
        {
            Server.Transfer("Print_KOT.aspx?table_no=" + tableNo + "&kotno=" + kotNo+"");
        }
        Response.Redirect("Dashboard.aspx");
    }
    private string GenerateKOTNo()
    {
        SqlCommand cmd = new SqlCommand("SELECT ISNULL(MAX(CAST(KOT_No AS INT)), 0) + 1 FROM KOT_Master", cl.con);

        cl.con.Open();
        int nextNo = Convert.ToInt32(cmd.ExecuteScalar());
        cl.con.Close();

        return nextNo.ToString("000");
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        SaveFinalBill(false);
    }

    protected void btnSavePrint_Click(object sender, EventArgs e)
    {
        SaveFinalBill(true);
    }
    public void GenerateBill()
    {
        int len = 0;
        string id = null;
        string st = null;
        int i = 0;
        cl.con.Open();
        st = cl.Scalar("Select ISNULL(max(convert(int,replace(Bill_No,'CR',''))),0) as Bill_No from Bill_master");
        i = Convert.ToInt32(st);
        id = (i + 1).ToString();
        len = id.Length;
        switch (len)
        {
            case 1:
                id = "0000" + id;
                break;
            case 2:
                id = "000" + id;
                break;
            case 3:
                id = "00" + id;
                break;
            case 4:
                id = "0" + id;
                break;
        }
        string re = "CR";
        lblbillno.Text = re + id;
        cl.con.Close();
    }
    private void SaveFinalBill(bool isPrint)
    {
        if (Session["BillTable"] == null) return;
        DataTable dt = (DataTable)Session["BillTable"];
        if (dt.Rows.Count == 0) return;

        string tableNo = hfTableNo.Value;

        using (SqlConnection con = new SqlConnection(cl.con.ConnectionString))
        {
            con.Open();
            using (SqlTransaction tran = con.BeginTransaction())
            {
                try
                {
                    SqlCommand cmdBill = new SqlCommand("INSERT INTO Bill_Master(Bill_No, Table_No, SubTotal, Tax, GrandTotal, PaidAmount, ReturnAmount, PaymentMode, IsPaid,IsRunning,billTime,Discount,DeliveryCharge,Bill_date,RoundOff) OUTPUT INSERTED.Bill_ID VALUES(@BillNo, @TableNo, @SubTotal, @Tax, @GrandTotal, @Paid, @Return, @PayMode, @IsPaid,1,@billTime,@Discount,@DeliveryCharge,GETUTCDATE(),@RoundOff)", con, tran);

                    cmdBill.Parameters.AddWithValue("@BillNo", lblbillno.Text);
                    cmdBill.Parameters.AddWithValue("@TableNo", tableNo);
                    cmdBill.Parameters.AddWithValue("@SubTotal", lblSubTotal.Text);
                    cmdBill.Parameters.AddWithValue("@Tax", lblTax.Text);
                    cmdBill.Parameters.AddWithValue("@GrandTotal", lblGrandTotal.Text);
                    cmdBill.Parameters.AddWithValue("@Paid", string.IsNullOrEmpty(txtCustomerPaid.Text) ? 0 : Convert.ToDecimal(txtCustomerPaid.Text));
                    cmdBill.Parameters.AddWithValue("@Return", lblReturn.Text);
                    cmdBill.Parameters.AddWithValue("@PayMode", rbCash.Checked ? "Cash" : rbCard.Checked ? "Card" : rbUPI.Checked ? "UPI" : "Other");
                    cmdBill.Parameters.AddWithValue("@IsPaid", chkPaid.Checked);
                    cmdBill.Parameters.AddWithValue("@billTime", dateTime.ToString("hh:mm tt"));
                    cmdBill.Parameters.AddWithValue("@Discount", txtdiscount.Text);
                    cmdBill.Parameters.AddWithValue("@DeliveryCharge", txtdilivery.Text);
                    cmdBill.Parameters.AddWithValue("@RoundOff", lblRoundOff.Text);

                    int billId = Convert.ToInt32(cmdBill.ExecuteScalar());

                    foreach (DataRow r in dt.Rows)
                    {
                        SqlCommand cmdItem = new SqlCommand("INSERT INTO Bill_Detail(Bill_ID, ItemName, Rate, Qty, Amount,sku,gst_per) VALUES(@BillID, @Item, @Rate, @Qty, @Amount,@sku,@gst_per)", con, tran);

                        cmdItem.Parameters.AddWithValue("@BillID", billId);
                        cmdItem.Parameters.AddWithValue("@Item", r["ItemName"]);
                        cmdItem.Parameters.AddWithValue("@Rate", r["Rate"]);
                        cmdItem.Parameters.AddWithValue("@Qty", r["Qty"]);
                        cmdItem.Parameters.AddWithValue("@Amount", r["Amount"]);
                        cmdItem.Parameters.AddWithValue("@sku", r["SKU"]);
                        cmdItem.Parameters.AddWithValue("@gst_per", r["GST"]);

                        cmdItem.ExecuteNonQuery();
                    }
                    SqlCommand cmdCloseKot = new SqlCommand("UPDATE KOT_Master SET IsClosed = 1,billno='"+ lblbillno.Text + "' WHERE Table_No=@TableNo AND IsClosed=0", con, tran);
                    cmdCloseKot.Parameters.AddWithValue("@TableNo", tableNo);
                    cmdCloseKot.ExecuteNonQuery();

                    tran.Commit();
                    
                }
                catch
                {
                    try { tran.Rollback(); } catch { }
                    throw;
                }
            }
        }
        dt.Clear();
        Session["BillTable"] = dt;
        gvBill.DataSource = dt;
        gvBill.DataBind();
        CalculateBill();
        
        if (isPrint)
        {
            Server.Transfer("Restaurant_Billing.aspx?billno=" + lblbillno.Text + "&tableno=" + tableNo + "");
        }
        GenerateBill();
        Response.Redirect("Dashboard.aspx");
    }
    protected void Button1_Click(object sender, EventArgs e)
    {
        Response.Redirect("Dashboard.aspx");
    }
}