using System;
using System.Activities.Expressions;
using System.Activities.Statements;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Drawing.Drawing2D;
using System.Globalization;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Bill : System.Web.UI.Page
{
    Class2 cl = new Class2();
    Cls_connection cls = new Cls_connection();
    public static TimeZoneInfo timeZoneInfo = TimeZoneInfo.FindSystemTimeZoneById("India Standard Time");
    public static DateTime dateTime;
    public static string billno = "";
    public static string billid = "";
    public static string autoid = "";
    public static string billnoc = "";
    private int PageSize = 10;
    private int CurrentPage
    {
        get { return ViewState["CurrentPage"] == null ? 0 : (int)ViewState["CurrentPage"]; }
        set { ViewState["CurrentPage"] = value; }
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        dateTime = TimeZoneInfo.ConvertTime(DateTime.Now, timeZoneInfo);
        if (!IsPostBack)
        {
            if (Session["Admin"] != null && Session["Admin"] != null)
            {
                txtitemcode.Focus();
                billid = cl.Scalar("SELECT ISNULL(MAX(CAST(Bid AS INT)) + 1, 1) AS id FROM Bill");
                txtpid.Text = billid;
                autoid = cl.Scalar("SELECT ISNULL(MAX(CAST(pid AS INT)) + 1, 1) AS id FROM Gstparty");
                autid.Text = autoid;
                txtbilldate.Text = dateTime.ToString("dd/MM/yyyy");
                generatebillno();
                //txtdob.Text = dateTime.ToString("yyyy-MM-dd");
                //txtannievr.Text = dateTime.ToString("yyyy-MM-dd");

            }
            else
            {
                Response.Redirect("login.aspx");
            }
        }
    }
    public void generatebillno()
    {
        int len = 0;
        string id = null;
        string st = null;
        int count = 0;
        int i = 0;
        string vou = null;
        string prefix = cl.Scalar("select prefix from MVbillprefix");
        vou = "Select ISNULL(max(convert(int,bill_index)),0) as bill_index FROM Bill";
        count = Convert.ToInt32(cl.Scalar(vou));
        if (count > 0)
        {
            st = cl.Scalar("Select ISNULL(max(convert(int,bill_index)),0) as bill_index from Bill");
            i = Convert.ToInt32(st);
            id = (i + 1).ToString();
            Console.WriteLine("Generated Bill Number: " + id);
        }
        else
        {
            id = "00001";
        }
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
        lblbillno1.Text = prefix + id;
        billno = id;
        Console.WriteLine("Final Bill Number: " + lblbillno1.Text);
    }
    [WebMethod]
    public static string InsertData(string lcgst, string lsgst, string llabel25, string billno1, string lbltend, string lblcard, string type, string no1, string no2, string upi, string radioValue, string autid, string txtname, string txtgstn, string txtadd, string billnoc1, string dis, string mob, string diss, string txtmobileno, string partyna, string subtotl, string emailadd, string dob, string wedding)
    {

        Class2 cl = new Class2();
        try
        {
            if (string.IsNullOrWhiteSpace(partyna) || partyna.Trim().Length == 0)
            {
                return "Error: Party name is required.";
            }

            if (string.IsNullOrWhiteSpace(txtmobileno) || txtmobileno.Trim().Length == 0)
            {
                return "Error: Mobile number is required.";
            }

            if (!System.Text.RegularExpressions.Regex.IsMatch(txtmobileno.Trim(), @"^[0-9]{10}$"))
            {
                return "Error: Please enter a valid 10-digit mobile number.";
            }

            DateTime dateTime = DateTime.Now;
            decimal cgstValue = 0;
            decimal sgstValue = 0;
            decimal totalValue = 0;

            if (!decimal.TryParse(lcgst, out cgstValue)) cgstValue = 0;
            if (!decimal.TryParse(lsgst, out sgstValue)) sgstValue = 0;
            if (!decimal.TryParse(llabel25, out totalValue)) totalValue = 0;

            if (radioValue == "1") radioValue = "Cash Sale";
            else if (radioValue == "2") radioValue = "Member Sale";
            else if (radioValue == "3") radioValue = "Card Sale";
            else if (radioValue == "4") radioValue = "Credit Note Sale";
            else if (radioValue == "5") radioValue = "GSTIN Bill";
            else if (radioValue == "6") radioValue = "UPI Sale";
            else if (radioValue == "7") radioValue = "Sudaskho Sale";
            else radioValue = "Unknown";
            string updatedBillno = "";
            string updatedindex = "";
            string updateinde = "";
            if (radioValue == "Credit Note Sale")
            {
                updatedBillno = billnoc1;
                updatedindex = billnoc;
            }
            else
            {
                updatedBillno = billno1;
                updateinde = billno;
            }
            string query = "UPDATE Bill SET cgst = @cgst, sgst = @sgst, tend = @tend, total = @total, upduser = @upduser, upddate = @upddate, updyear = @updyear, updtime = @updtime, paymentmode = @paymentmode, mcardno = @mcardno, ctype = @ctype, cno = @cno, cnsno = @cnsno, UPI = @UPI, Billno = @billcn,DiscountPrice = @DiscountPrice,Partyname = @Partyname,Mobileno = @Mobileno,AddDiscount = @AddDiscount,flag = @flag , ishold = 0,txtamt = @txtamt,Email = @Email,DOB = @DOB,weddingdate = @weddingdate WHERE Billno = @Billno";
            using (SqlCommand cmd = new SqlCommand(query, cl.con))
            {
                cmd.Parameters.AddWithValue("@cgst", cgstValue);
                cmd.Parameters.AddWithValue("@sgst", sgstValue);
                cmd.Parameters.AddWithValue("@tend", lbltend);
                cmd.Parameters.AddWithValue("@total", totalValue);
                cmd.Parameters.AddWithValue("@Billno", billno1);
                cmd.Parameters.AddWithValue("@billcn", updatedBillno);
                cmd.Parameters.AddWithValue("@DiscountPrice", dis);
                var httpContext = HttpContext.Current;
                if (httpContext.Session["Admin"] == null)
                {
                    return "Session expired. Please log in again.";
                }
                cmd.Parameters.AddWithValue("@upduser", httpContext.Session["Admin"].ToString());
                cmd.Parameters.AddWithValue("@upddate", dateTime.ToString("yyyy-MM-dd"));
                cmd.Parameters.AddWithValue("@updyear", dateTime.Year);
                cmd.Parameters.AddWithValue("@updtime", dateTime.ToString("hh:mm:ss tt"));
                cmd.Parameters.AddWithValue("@paymentmode", radioValue);
                cmd.Parameters.AddWithValue("@mcardno", lblcard);
                cmd.Parameters.AddWithValue("@txtamt", subtotl);
                cmd.Parameters.AddWithValue("@ctype", type);
                cmd.Parameters.AddWithValue("@cno", no1);
                cmd.Parameters.AddWithValue("@cnsno", no2);
                cmd.Parameters.AddWithValue("@UPI", upi);
                cmd.Parameters.AddWithValue("@Partyname", partyna);
                cmd.Parameters.AddWithValue("@Mobileno", txtmobileno);
                cmd.Parameters.AddWithValue("@Email", emailadd);
                cmd.Parameters.AddWithValue("@DOB", dob);
                cmd.Parameters.AddWithValue("@weddingdate", wedding);
                cmd.Parameters.AddWithValue("@AddDiscount", diss);
                cmd.Parameters.AddWithValue("@flag", "1");

                cl.con.Open();
                cmd.ExecuteNonQuery();
                cl.con.Close();
            }
            if (radioValue == "GSTIN Bill")
            {
                string query1 = "INSERT INTO Gstparty (pid, Billnoo, party,GSTin, Address, insuser, insdate, insyear, instime)VALUES (@pid, @Billnoo, @party,@GSTin,@Address, @insuser, @insdate, @insyear, @instime)";
                using (SqlCommand cmd = new SqlCommand(query1, cl.con))
                {
                    cmd.Parameters.AddWithValue("@pid", autid);
                    cmd.Parameters.AddWithValue("@Billnoo", billno1);
                    cmd.Parameters.AddWithValue("@party", txtname);
                    cmd.Parameters.AddWithValue("@GSTin", txtgstn);
                    cmd.Parameters.AddWithValue("@Address", txtadd);
                    var httpContext = HttpContext.Current;
                    if (httpContext.Session["Admin"] == null)
                    {
                        return "Session expired. Please log in again.";
                    }
                    cmd.Parameters.AddWithValue("@insuser", httpContext.Session["Admin"].ToString());
                    cmd.Parameters.AddWithValue("@insdate", dateTime.ToString("yyyy-MM-dd"));
                    cmd.Parameters.AddWithValue("@insyear", dateTime.ToString("yyyy"));
                    cmd.Parameters.AddWithValue("@instime", dateTime.ToString("hh:mm:ss tt"));
                    cl.con.Open();
                    cmd.ExecuteNonQuery();
                    cl.con.Close();

                }
            }
            return "Data inserted successfully!";
        }
        catch (SqlException sqlEx)
        {
            Console.WriteLine("SQL Exception: " + sqlEx.Message);
            return "Database error: " + sqlEx.Message;
        }
    }
    public DataTable GetItemDetailsFromDatabase(string itemCode)
    {
        string query = "SELECT Itemdiscription, GSTper, Saleprice FROM Productmaster WHERE sku = @ItemCode";
        SqlCommand cmd = new SqlCommand(query, cl.con);
        cmd.Parameters.AddWithValue("@ItemCode", itemCode);
        SqlDataAdapter adapter = new SqlDataAdapter(cmd);
        DataTable dt = new DataTable();
        adapter.Fill(dt);
        return dt;

    }
    protected void btnAddData12_Click(object sender, EventArgs e)
    {
        SaveBill(0, 0);
    }
    public void SaveBill(int holdFlag, int flag)
    {

        dateTime = TimeZoneInfo.ConvertTime(DateTime.Now, timeZoneInfo);
        try
        {
            if (string.IsNullOrWhiteSpace(txtitemcode.Text) ||
                string.IsNullOrWhiteSpace(txtqty.Text) ||
                string.IsNullOrWhiteSpace(txtrate.Text) ||
                string.IsNullOrWhiteSpace(txtamt.Text) ||
                string.IsNullOrWhiteSpace(lblbillno1.Text))
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "alert",
                    "savealert('Please fill in all fields!','warning');", true);
                return;
            }
            string itemCode = txtitemcode.Text.Trim();
            string itemName = txtitem.Text.Trim();
            string rate = txtrate.Text.Trim();

            string checkQuery = "SELECT COUNT(*) FROM ProductMaster WHERE Sku = @icode AND itemdiscription = @iname AND saleprice = @rate";
            using (SqlCommand checkCmd = new SqlCommand(checkQuery, cl.con))
            {
                checkCmd.Parameters.AddWithValue("@icode", itemCode);
                checkCmd.Parameters.AddWithValue("@iname", itemName);
                checkCmd.Parameters.AddWithValue("@rate", rate);

                cl.con.Open();
                int exists = Convert.ToInt32(checkCmd.ExecuteScalar());
                cl.con.Close();

                if (exists == 0)
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "alert",
                        "savealert('Item does not exist in Product Master!','error');", true);
                    return;
                }
            }
            DateTime billDate;
            if (!DateTime.TryParseExact(txtbilldate.Text.Trim(), "dd/MM/yyyy",
                CultureInfo.InvariantCulture, DateTimeStyles.None, out billDate))
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "alert",
                    "savealert('Invalid Bill Date format!','error');", true);
                return;
            }
            if (Button2.Text == "Update" && !string.IsNullOrWhiteSpace(txtid.Text))
            {
                string updateQuery = "UPDATE Bill SET Itemcode = @Itemcode, Itemname = @Itemname, gst = @gst, qty = @qty, rate = @rate, amt = @amt, discountper = @discountper,disamt = @disamt, upuser = @user, updateDate = @date, updatetime = @time,flag1 = @flag1 WHERE id = @id";

                using (SqlCommand cmd = new SqlCommand(updateQuery, cl.con))
                {
                    cmd.Parameters.AddWithValue("@Itemcode", itemCode);
                    cmd.Parameters.AddWithValue("@Itemname", itemName);
                    cmd.Parameters.AddWithValue("@gst", txtgst.Text);
                    cmd.Parameters.AddWithValue("@qty", txtqty.Text);
                    cmd.Parameters.AddWithValue("@rate", rate);
                    cmd.Parameters.AddWithValue("@amt", txtamt.Text);
                    cmd.Parameters.AddWithValue("@discountper", txtdisss.Text);
                    cmd.Parameters.AddWithValue("@disamt", txtdiscout.Text);
                    cmd.Parameters.AddWithValue("@user", Session["Admin"].ToString());
                    cmd.Parameters.AddWithValue("@date", dateTime.ToString("yyyy-MM-dd"));
                    cmd.Parameters.AddWithValue("@time", dateTime.ToString("hh:mm:ss tt"));
                    cmd.Parameters.AddWithValue("@flag1", 1);
                    cmd.Parameters.AddWithValue("@id", txtid.Text);

                    cl.con.Open();
                    cmd.ExecuteNonQuery();
                    cl.con.Close();

                    ScriptManager.RegisterStartupScript(this, this.GetType(), "alert",
                        "savealert('Record updated successfully!','success');", true);
                    ClearFields();
                    binddetail(lblbillno1.Text);
                    Button2.Text = "Add";
                    return;
                }
            }
            string insertQuery = "INSERT INTO Bill (Bid, Billno, Billdate, Itemcode, Itemname, gst, qty, rate, amt, bill_index, insuser, insdate, insyear, instime, discountper, IsHold, flag,disamt) VALUES(@Bid, @Billno, @Billdate, @Itemcode, @Itemname, @gst, @qty, @rate, @amt,@bill_index, @insuser, @insdate, @insyear, @instime, @discountper, @IsHold, @flag,@disamt)";

            using (SqlCommand cmd = new SqlCommand(insertQuery, cl.con))
            {
                cmd.Parameters.AddWithValue("@Bid", txtpid.Text);
                cmd.Parameters.AddWithValue("@Billno", lblbillno1.Text);
                cmd.Parameters.AddWithValue("@Billdate", billDate);
                cmd.Parameters.AddWithValue("@Itemcode", itemCode);
                cmd.Parameters.AddWithValue("@Itemname", itemName);
                cmd.Parameters.AddWithValue("@gst", txtgst.Text);
                cmd.Parameters.AddWithValue("@qty", txtqty.Text);
                cmd.Parameters.AddWithValue("@rate", rate);
                cmd.Parameters.AddWithValue("@amt", txtamt.Text);
                cmd.Parameters.AddWithValue("@disamt", txtdiscout.Text);
                cmd.Parameters.AddWithValue("@discountper", txtdisss.Text);
                cmd.Parameters.AddWithValue("@bill_index", billno);
                cmd.Parameters.AddWithValue("@insuser", Session["Admin"].ToString());
                cmd.Parameters.AddWithValue("@insdate", dateTime.ToString("yyyy-MM-dd"));
                cmd.Parameters.AddWithValue("@insyear", dateTime.ToString("yyyy"));
                cmd.Parameters.AddWithValue("@instime", dateTime.ToString("HH:mm:ss tt"));
                cmd.Parameters.AddWithValue("@IsHold", holdFlag);
                cmd.Parameters.AddWithValue("@flag", flag);

                cl.con.Open();
                cmd.ExecuteNonQuery();
                cl.con.Close();

                //ScriptManager.RegisterStartupScript(this, this.GetType(), "alert",
                //    "savealert('Item added successfully!','success');", true);
                ClearFields();
                binddetail(lblbillno1.Text);
            }
        }
        catch (Exception ex)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "alert",
                "savealert('Error: " + ex.Message.Replace("'", "") + "','error');", true);
        }
    }

    private void ClearFields()
    {
        txtid.Text = "";
        txtitemcode.Text = "";
        txtitem.Text = "";
        txtqty.Text = "";
        txtrate.Text = "";
        txtgst.Text = "";
        txtdisss.Text = "";
        txtamt.Text = "";
        txtdiscout.Text = "";
    }

    protected void lbledit_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            ImageButton button1 = (ImageButton)sender;
            GridViewRow row = (GridViewRow)button1.Parent.Parent;
            Label lblgrpid2 = ((Label)row.FindControl("lblid") as Label);
            cl.adp.SelectCommand.Parameters.Clear();
            DataTable dt = new DataTable();
            cl.adp.SelectCommand.Parameters.Clear();
            cl.adp.SelectCommand.CommandText = "SELECT id ,bid,Itemcode, Itemname, gst, qty, rate, amt,discountper,disamt FROM bill where id = @id;";
            cl.adp.SelectCommand.Parameters.AddWithValue("@id", lblgrpid2.Text);
            cl.adp.Fill(dt);
            if (dt.Rows.Count > 0)
            {
                txtid.Text = dt.Rows[0]["id"].ToString();
                txtpid.Text = dt.Rows[0]["bid"].ToString();
                txtitemcode.Text = dt.Rows[0]["Itemcode"].ToString();
                txtitem.Text = dt.Rows[0]["Itemname"].ToString();
                txtgst.Text = dt.Rows[0]["gst"].ToString();
                txtqty.Text = dt.Rows[0]["qty"].ToString();
                txtrate.Text = dt.Rows[0]["rate"].ToString();
                txtdisss.Text = dt.Rows[0]["discountper"].ToString();
                txtdiscout.Text = dt.Rows[0]["disamt"].ToString();
                txtamt.Text = dt.Rows[0]["amt"].ToString();
                Button2.Text = "Update";

            }
        }
        catch (Exception ex)
        {
            Response.Write(ex.Message);
        }
    }
    public void binddetail(string bill)
    {
        try
        {
            string query = "SELECT id,bill_index,Billno, Billdate, Itemcode, Itemname, gst, qty, rate,discountper, amt,disamt FROM Bill where Billno = '" + bill + "'";
            SqlDataAdapter sda = new SqlDataAdapter(query, cl.con);
            DataTable dt = new DataTable();
            sda.Fill(dt);
            if (dt.Rows.Count > 0)
            {
                lblbillno1.Text = dt.Rows[0]["Billno"].ToString();
                billno = dt.Rows[0]["bill_index"].ToString();
                gridview1.DataSource = dt;
                gridview1.DataBind();
            }
            else
            {
                gridview1.DataSource = null;
                gridview1.DataBind();
            }
        }
        catch (Exception ex)
        {
            Response.Write(ex.Message);
        }
    }
    protected void gvHoldBills_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "SelectBill")
        {
            string billNo = e.CommandArgument.ToString();
            binddetail(billNo);
        }
    }
    protected void btnHold_Click(object sender, EventArgs e)
    {
        if (gridview1.Rows.Count == 0)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(),
                "alert",
                "Swal.fire({ icon: 'warning', title: 'Oops...', text: 'Please add item before hold bill!' });",
                true);
            return;
        }

        HoldBill(lblbillno1.Text);
    }
    public void HoldBill(string billno)
    {
        try
        {
            string query = "UPDATE Bill SET IsHold = 1, cgst = @cgst, sgst = @sgst, total = @total,Discountprice = @Discountprice where Billno = @Billno";
            using (SqlCommand cmd = new SqlCommand(query, cl.con))
            {
                cmd.Parameters.AddWithValue("@Billno", billno);
                cmd.Parameters.AddWithValue("@cgst", lblcgst.Text);
                cmd.Parameters.AddWithValue("@sgst", lblsgst.Text);
                cmd.Parameters.AddWithValue("@total", lbltotal.Text);
                cmd.Parameters.AddWithValue("@Discountprice", lbldis.Text);

                cl.con.Open();
                int n = cmd.ExecuteNonQuery();
                cl.con.Close();

                if (n > 0)
                {
                    Response.Write("<script>alert('Bill Hold Successfully');</script>");
                    generatebillno();
                    gridview1.DataSource = null;
                    gridview1.DataBind();
                    lblcgst.Text = "";
                    lblsgst.Text = "";
                    lbltotal.Text = "";
                    txtbillamt.Text = "";
                    lbldis.Text = "";
                }

            }
        }
        catch (Exception ex)
        {
            Response.Write(ex.Message);
        }
    }
    protected void btnFinalize_Click(object sender, EventArgs e)
    {
        string query = "SELECT bill_index,BillNo, itemcode,ItemName, Qty, Rate, Amt,discountper,cgst,sgst,total FROM Bill WHERE IsHold = 1";
        SqlDataAdapter da = new SqlDataAdapter(query, cl.con);
        DataTable dt = new DataTable();
        da.Fill(dt);
        if (dt.Rows.Count > 0)
        {
            gvHoldBills.DataSource = dt;
            gvHoldBills.DataBind();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Pop",
            "var modal = new bootstrap.Modal(document.getElementById('HoldBillModal')); modal.show();", true);
        }
        else
        {
            string script = "Swal.fire({ icon: 'info', title: 'No Hold Bills', text: 'There are no hold bills available!' });";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Swal", script, true);
        }
    }
    public int GetItemStock(string itemCode, string rate)
    {

        //SELECT ISNULL((SELECT SUM(CAST(Qty AS decimal(18, 2))) FROM Temtpurchase WHERE ItemCode = @ItemCode AND Rate = @Rate), 0) +ISNULL((SELECT SUM(CAST(Qty AS decimal(18, 2))) FROM CNBill WHERE ItemCode = @ItemCode AND Rate = @Rate), 0) -ISNULL((SELECT SUM(CAST(Qty AS decimal(18, 2))) FROM Bill WHERE ItemCode = @ItemCode AND Rate = @Rate and flag = 1), 0)  -ISNULL((SELECT SUM(CAST(Qty AS decimal(18, 2))) FROM ESTIBill WHERE ItemCode = @ItemCode AND Rate = @Rate), 0) AS AvailableStock

        decimal rateValue = Convert.ToDecimal(rate);

        string query = "SELECT ISNULL((SELECT SUM(CAST(Qty AS decimal(18, 2))) FROM Temtpurchase WHERE ItemCode = @ItemCode AND Rate = @Rate), 0) + ISNULL((SELECT SUM(CAST(Qty AS decimal(18, 2))) FROM CNBill WHERE ItemCode = @ItemCode AND Rate = @Rate), 0) - ISNULL((SELECT SUM(CAST(Qty AS decimal(18, 2))) FROM Bill WHERE ItemCode = @ItemCode AND Rate = @Rate AND flag = 1), 0)  - ISNULL((SELECT SUM(CAST(Qty AS decimal(18, 2))) FROM ESTIBill WHERE ItemCode = @ItemCode AND Rate = @Rate AND flag = 1), 0)  AS AvailableStock";

        SqlCommand cmd = new SqlCommand(query, cl.con);
        cmd.Parameters.AddWithValue("@ItemCode", itemCode);
        cmd.Parameters.AddWithValue("@Rate", rateValue);

        cl.con.Open();
        object result = cmd.ExecuteScalar();
        cl.con.Close();

        return Convert.ToInt32(result);
    }
    protected void txtmobile_TextChanged(object sender, EventArgs e)
    {
        cl.adp.SelectCommand.Parameters.Clear();
        DataTable dt1 = new DataTable();
        try
        {
            if (!string.IsNullOrWhiteSpace(txtmobile.Text))
            {
                cl.adp.SelectCommand.CommandText = "SELECT Supname, Mobile, GSTIN, Address FROM SupplierMaster WHERE Mobile = @Mobile";
                cl.adp.SelectCommand.Parameters.AddWithValue("@Mobile", txtmobile.Text);
                cl.adp.Fill(dt1);
                if (dt1.Rows.Count > 0)
                {
                    txtmobile.Text = dt1.Rows[0]["Mobile"].ToString();
                    txtname.Text = dt1.Rows[0]["Supname"].ToString();
                    txtgstn.Text = dt1.Rows[0]["GSTIN"].ToString();
                    txtadd.Text = dt1.Rows[0]["Address"].ToString();
                    txtname1.Text = dt1.Rows[0]["Supname"].ToString();
                    txtaddress.Text = dt1.Rows[0]["Address"].ToString();
                }
            }
            else
            {
                string message = "Please enter a mobile number. !!";
                string type = "warning";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Script", "savealert('" + message + "','" + type + "');", true);
            }
        }
        catch (Exception ex)
        {

        }
    }
    decimal totalAmount = 0;
    decimal totalDiscount = 0;
    decimal totalCGST = 0;
    decimal totalSGST = 0;
    decimal txamt = 0;
    int totalItems = 0;
    protected void gridview1_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            totalItems++;

            decimal discountPer = Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "discountper") ?? 0);
            decimal discountAmt = Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "disamt") ?? 0);
            decimal gstPer = Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "gst") ?? 0);
            decimal qty = Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "qty") ?? 0);
            decimal rate = Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "rate") ?? 0);

            decimal baseAmount = qty * rate;

            decimal rowDiscount = 0;

            if (discountAmt > 0)
                rowDiscount = discountAmt;
            else if (discountPer > 0)
                rowDiscount = (Math.Abs(baseAmount) * discountPer) / 100;

            if (baseAmount < 0)
                rowDiscount = -rowDiscount;

            decimal amountAfterDiscount = baseAmount - rowDiscount;
            decimal gstAmount = (amountAfterDiscount * gstPer) / (100 + gstPer);
            decimal cgst = gstAmount / 2;
            decimal sgst = gstAmount / 2;

            totalCGST += cgst;
            totalSGST += sgst;

            totalDiscount += rowDiscount;
            totalAmount += amountAfterDiscount;

            decimal amtWithoutGST = amountAfterDiscount - gstAmount;
            txamt += amtWithoutGST;
        }

        else if (e.Row.RowType == DataControlRowType.Footer)
        {
            var lblTotalAmount = (System.Web.UI.WebControls.Label)e.Row.FindControl("lblTotalAmount");
            var lblTotalDiscount = (System.Web.UI.WebControls.Label)e.Row.FindControl("lblTotalDiscount");
            var lblNetAmount = (System.Web.UI.WebControls.Label)e.Row.FindControl("lblNetAmount");

            if (lblTotalAmount != null)
                lblTotalAmount.Text = totalAmount.ToString("0.00");

            if (lblTotalDiscount != null)
                lblTotalDiscount.Text = totalDiscount.ToString("0.00");

        }
        lblItemCount.InnerHtml = totalItems.ToString();
        lbltotal.Text = totalAmount.ToString("0.00");
        // txtbillamt.Text = totalAmount.ToString("0.00");
        lblcgst.Text = totalCGST.ToString("0.00");
        lblsgst.Text = totalSGST.ToString("0.00");
        subtotal.Text = txamt.ToString("0.00");
        lblCGst1.Text = totalCGST.ToString("0.00");
        Label23.Text = totalSGST.ToString("0.00");
        Label25.Text = totalAmount.ToString("0.00");
        txtdis.Text = totalDiscount.ToString("0.00");
        lbldis.Text = totalDiscount.ToString("0.00");
        txtbillamt.Text = txamt.ToString("0.00");
    }
    protected void txttend_Leave(object sender, EventArgs e)
    {
        decimal totalAmount = Convert.ToDecimal(Label25.Text);
        decimal tenderedAmount;
        if (decimal.TryParse(txttend.Text, out tenderedAmount))
        {
            if (tenderedAmount < totalAmount)
            {
                string message = "Tendered amount should not be less than total amount.Invalid Amount";
                string type = "warning";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Script", "savealert('" + message + "','" + type + "')", true);
                txttend.Text = totalAmount.ToString("0.00");
                txttend.Focus();
                return;
            }
        }
        else
        {
            string message = "Please enter a valid amount !";
            string type = "warning";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Script", "savealert('" + message + "','" + type + "')", true);

            txttend.Text = totalAmount.ToString("0.00");
            txttend.Focus();
            return;
        }
    }
    protected void txtno2_TextChanged(object sender, EventArgs e)
    {
        try
        {
            string billno = txtno2.Text.Trim();
            if (!billno.StartsWith("MJ"))
            {
                ltTable.Text = "<p>The Billno must start with 'MJ'.</p>";
                return;
            }
            string query = "SELECT COUNT(*) FROM Bill WHERE Billno = @Billno";
            bool billExists = false;

            using (SqlCommand cmd = new SqlCommand(query, cl.con))
            {
                cmd.Parameters.AddWithValue("@Billno", billno);
                if (cl.con.State == ConnectionState.Closed)
                {
                    cl.con.Open();
                }
                int count = (int)cmd.ExecuteScalar();
                billExists = count > 0;
                cl.con.Close();
            }
            if (billExists)
            {
                string detailsQuery = "SELECT Itemname, qty, amt FROM Bill WHERE Billno = @Billno";
                System.Text.StringBuilder tableHtml = new StringBuilder();

                using (SqlCommand cmd = new SqlCommand(detailsQuery, cl.con))
                {
                    cmd.Parameters.AddWithValue("@Billno", billno);
                    if (cl.con.State == ConnectionState.Closed)
                    {
                        cl.con.Open();
                    }
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.HasRows)
                        {
                            tableHtml.Append("<style>table, th, td { padding: 0px !important; }</style>");
                            tableHtml.Append("<table class='table table-bordered'>");
                            tableHtml.Append("<thead><tr><th>Item Name</th><th>Quantity</th><th>Amount</th></tr></thead>");
                            tableHtml.Append("<tbody>");
                            while (reader.Read())
                            {
                                tableHtml.Append("<tr>");
                                tableHtml.Append("<td>" + reader["Itemname"].ToString() + "</td>");
                                tableHtml.Append("<td>" + reader["qty"].ToString() + "</td>");
                                tableHtml.Append("<td>" + reader["amt"].ToString() + "</td>");
                                tableHtml.Append("</tr>");
                            }

                            tableHtml.Append("</tbody>");
                            tableHtml.Append("</table>");
                        }
                        else
                        {
                            tableHtml.Append("<p>No records found for the given Billno.</p>");
                        }
                    }
                    cl.con.Close();
                }
                ltTable.Text = tableHtml.ToString();
            }
            else
            {
                string message = "The Billno does not exist in the database.";
                string type = "warning";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Script", "savealert('" + message + "','" + type + "');", true);
            }
        }
        catch (Exception ex)
        {
            Response.Write(ex.Message);
        }
    }
    protected void btnclose_Click(object sender, EventArgs e)
    {
        Response.Redirect("Bill.aspx");
    }
    private void binddetail1(string searchText = "")
    {
        string query = @"SELECT pm.pid,pm.sku, pm.Itemdiscription,pm.Saleprice,CASE WHEN pm.cloth = 1 AND pm.Saleprice < 2500 THEN 5 WHEN pm.cloth = 1 AND pm.Saleprice >= 2500 THEN 18 ELSE pm.gstper END AS gstper,pm.discountper, p.qty,pm.cloth FROM productmaster pm LEFT JOIN Temtpurchase p ON pm.sku = p.Itemcode AND pm.saleprice = p.rate WHERE TRY_CAST(p.qty AS decimal(18,2)) > 0";

        if (!string.IsNullOrEmpty(searchText))
        {
            query += " AND (pm.department LIKE @search OR pm.Itemdiscription LIKE @search)";
        }

        using (SqlCommand cmd = new SqlCommand(query, cl.con))
        {
            if (!string.IsNullOrEmpty(searchText))
            {
                cmd.Parameters.AddWithValue("@search", "%" + searchText + "%");
            }

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            da.Fill(dt);

            PagedDataSource pds = new PagedDataSource();
            pds.DataSource = dt.DefaultView;
            pds.AllowPaging = true;
            pds.PageSize = PageSize;
            if (CurrentPage >= pds.PageCount)
            {
                CurrentPage = pds.PageCount > 0 ? pds.PageCount - 1 : 0;
            }
            if (CurrentPage < 0)
            {
                CurrentPage = 0;
            }

            pds.CurrentPageIndex = CurrentPage;

            gridview3.DataSource = pds;
            gridview3.DataBind();

            lblPageInfo.Text = "Page " + (CurrentPage + 1) + " of " + pds.PageCount;
            lnkPrev.Enabled = !pds.IsFirstPage;
            lnkNext.Enabled = !pds.IsLastPage;
            ditext.Visible = true;
        }
    }

    public void binddetail2(string itemText = "")
    {
        string query = @"SELECT pm.pid,pm.sku, pm.Itemdiscription,pm.Saleprice,pm.discountper,CASE WHEN pm.cloth = 1 AND pm.Saleprice < 2500 THEN 5 WHEN pm.cloth = 1 AND pm.Saleprice >= 2500 THEN 18 ELSE pm.gstper END AS gstper,pm.discountper, p.qty ,pm.cloth FROM productmaster pm LEFT JOIN Temtpurchase p ON pm.sku = p.Itemcode AND pm.saleprice = p.rate WHERE TRY_CAST(p.qty AS decimal(18,2)) > 0";

        if (!string.IsNullOrEmpty(itemText))
        {
            query += " AND pm.sku LIKE @search";
        }

        using (SqlCommand cmd = new SqlCommand(query, cl.con))
        {
            if (!string.IsNullOrEmpty(itemText))
            {
                cmd.Parameters.AddWithValue("@search", "%" + itemText + "%");
            }

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            da.Fill(dt);

            PagedDataSource pds = new PagedDataSource();
            pds.DataSource = dt.DefaultView;
            pds.AllowPaging = true;
            pds.PageSize = PageSize;

            if (CurrentPage >= pds.PageCount)
            {
                CurrentPage = pds.PageCount > 0 ? pds.PageCount - 1 : 0;
            }
            if (CurrentPage < 0)
            {
                CurrentPage = 0;
            }

            pds.CurrentPageIndex = CurrentPage;

            gridview3.DataSource = pds;
            gridview3.DataBind();

            lblPageInfo.Text = "Page " + (CurrentPage + 1) + " of " + pds.PageCount;
            lnkPrev.Enabled = !pds.IsFirstPage;
            lnkNext.Enabled = !pds.IsLastPage;
            ditext.Visible = true;
        }
    }

    protected void btnClear_Click(object sender, EventArgs e)
    {
        txtSearch.Text = "";
        txtitemcode.Text = "";
        ViewState["FilterMode"] = "Search";
        CurrentPage = 0;
        binddetail1("");
    }
    protected void txtSearch_TextChanged(object sender, EventArgs e)
    {
        ViewState["FilterMode"] = "Search";
        CurrentPage = 0;
        binddetail1(txtSearch.Text);
    }
    protected void txtitemcode_TextChanged(object sender, EventArgs e)
    {
        ViewState["FilterMode"] = "Item";
        CurrentPage = 0;
        binddetail2(txtitemcode.Text.Trim());
    }
    protected void lnkPrev_Click(object sender, EventArgs e)
    {
        CurrentPage -= 1;
        ApplyFilter();
    }

    protected void lnkNext_Click(object sender, EventArgs e)
    {
        CurrentPage += 1;
        ApplyFilter();
    }

    private void ApplyFilter()
    {
        string mode = ViewState["FilterMode"] as string;

        if (mode == "Item")
        {
            binddetail2(txtitemcode.Text.Trim());
        }
        else
        {
            binddetail1(txtSearch.Text);
        }
    }
    protected void gridview3_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            string code = DataBinder.Eval(e.Row.DataItem, "Sku").ToString();
            string itemName = DataBinder.Eval(e.Row.DataItem, "Itemdiscription").ToString();
            string qty = DataBinder.Eval(e.Row.DataItem, "Qty").ToString();
            string rate = DataBinder.Eval(e.Row.DataItem, "Saleprice").ToString();
            int availQty = GetItemStock(code, rate);

            string cloth = DataBinder.Eval(e.Row.DataItem, "cloth").ToString();
            decimal saleprice = Convert.ToDecimal(rate);

            string gst;
            if (cloth == "1")
            {
                gst = saleprice < 2500 ? "5" : "18";
            }
            else
            {
                gst = DataBinder.Eval(e.Row.DataItem, "gstper").ToString();
            }

            string dis = DataBinder.Eval(e.Row.DataItem, "discountper").ToString();

            itemName = itemName.Replace("'", "\\'");

            e.Row.Attributes["onclick"] =
                "fillData('" + code + "','" + itemName + "','" + qty + "','" + rate + "','" + gst + "','" + availQty + "','" + dis + "');";

            e.Row.Style["cursor"] = "pointer";
        }
    }



}
