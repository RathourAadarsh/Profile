using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Item_Master : System.Web.UI.Page
{

    Class1 cl = new Class1();
    public static TimeZoneInfo timeZoneInfo = TimeZoneInfo.FindSystemTimeZoneById("India Standard Time");
    public static DateTime dateTime;
    protected void Page_Load(object sender, EventArgs e)
    {
        dateTime = TimeZoneInfo.ConvertTime(DateTime.Now, timeZoneInfo);
        if (!IsPostBack)
        {
            txtitemsku.Text = cl.Scalar("Select isnull(max(SKU+1),1) SKU from Item_detail");
            bindItemgroup();
            binditemdetail();
        }
    }
    protected void btnsave_Click(object sender, EventArgs e)
    {
        try
        {
            string[] allowedImageExts = { ".jpg", ".jpeg", ".png" };
            string profileExt = Path.GetExtension(fuProfile.FileName).ToLower();
            if (!allowedImageExts.Contains(profileExt))
            {
                ShowError("Only JPG, JPEG, or PNG files are allowed for Profile Image.");
                return;
            }
            string uploadFolder = Server.MapPath("~/ProductImages/");
            if (!Directory.Exists(uploadFolder)) Directory.CreateDirectory(uploadFolder);
            string profileFileName = Guid.NewGuid() + profileExt;
            fuProfile.SaveAs(Path.Combine(uploadFolder, profileFileName));
            string profileUrl = "ProductImages/" + profileFileName;

            if (ddlitemgroup.SelectedItem.Text == "--Select Item Group--")
            {
                Response.Write("<script>alert('Please Choose Item Group Name!!')</script>");
                return;
            }
            else if (txtitemname.Text == "")
            {
                Response.Write("<script>alert('Please Enter Item Name!!')</script>");
                return;
            }
            else if (btnsave.Text == "Save")
            {

                string query = "insert into Item_detail(SKU,Item_Name,Item_group_name,item_sale_rate,item_Unit,InsTime,Indate,insuser,Productimage) values('" + txtitemsku.Text + "','" + txtitemname.Text + "','" + ddlitemgroup.SelectedItem.Text + "','" + txtrate.Text + "','" + txtunit.Text + "','" + dateTime.ToString("hh:mm:ss tt") + "','" + dateTime.ToString("yyyy-KMM-dd") + "','" + Session["Admin"].ToString() + "','" + profileUrl + "')";
                SqlCommand cmd = new SqlCommand(query, cl.con);
                cl.con.Open();
                int n = cmd.ExecuteNonQuery();
                if (n > 0)
                {
                    Response.Write("<script language='javascript'>window.alert('Item Name Added Successfully!!');window.location=('Item_Master.aspx');</script>");
                }
            }
            else if (btnsave.Text == "Update")
            {
                string query = "update Item_detail set item_name='" + txtitemname.Text + "',Item_group_name='" + ddlitemgroup.SelectedItem.Text + "',item_sale_rate='" + txtrate.Text + "',item_Unit='" + txtunit.Text + "',upddate='" + dateTime.ToString("yyyy-KMM-dd") + "',updtime='" + dateTime.ToString("hh:mm:ss tt") + "',upduser='" + Session["Admin"].ToString() + "', Productimage = '" + profileUrl + "' where sku='" + txtitemsku.Text + "' and item_group_name='" + ddlitemgroup.SelectedItem.Text + "'";
                SqlCommand cmd = new SqlCommand(query, cl.con);
                cl.con.Open();
                int n = cmd.ExecuteNonQuery();
                if (n > 0)
                {
                    Response.Write("<script language='javascript'>window.alert('Item Name Updated Successfully!!');window.location=('Item_Master.aspx');</script>");
                }
            }

        }
        catch (Exception ex)
        {

        }
    }
    private void ShowError(string msg)
    {
        msg = msg.Replace("'", "\\'");
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert",
            "Swal.fire('Error!', '" + msg + "', 'error');", true);
    }
    private void ShowSuccess(string msg)
    {
        msg = msg.Replace("'", "\\'");
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert",
            "Swal.fire('Success!', '" + msg + "', 'success');", true);
    }
    protected void btncancel_Click(object sender, EventArgs e)
    {
        Response.Redirect("Item_Master.aspx");
    }
    protected void imgedit_Click(object sender, ImageClickEventArgs e)
    {
        ImageButton button1 = (ImageButton)sender;
        GridViewRow row = (GridViewRow)button1.Parent.Parent;
        Label sku = ((Label)row.FindControl("lblsku") as Label);
        Label item = ((Label)row.FindControl("lbliname") as Label);
        string query1 = "select sku,item_name,item_group_name,item_sale_rate,item_group_name,item_unit from Item_detail where sku='" + sku.Text + "' and item_name='" + item.Text + "'";
        SqlDataAdapter sda = new SqlDataAdapter(query1, cl.con);
        DataTable dt = new DataTable();
        sda.Fill(dt);
        if (dt.Rows.Count > 0)
        {
            txtitemname.Text = dt.Rows[0]["item_name"].ToString();
            ddlitemgroup.SelectedItem.Text = dt.Rows[0]["item_group_name"].ToString();
            txtitemsku.Text = dt.Rows[0]["sku"].ToString();
            txtrate.Text = dt.Rows[0]["item_sale_rate"].ToString();
            txtunit.Text = dt.Rows[0]["item_unit"].ToString();
            btnsave.Text = "Update";
        }
    }
    public void bindItemgroup()
    {
        SqlCommand cmd = new SqlCommand("select Item_G_Id,Item_G_Name from item_group_master ", cl.con);
        SqlDataAdapter sda = new SqlDataAdapter(cmd);
        DataTable dt = new DataTable();
        sda.Fill(dt);
        if (dt.Rows.Count > 0)
        {
            ddlitemgroup.DataValueField = "Item_G_Id";
            ddlitemgroup.DataTextField = "Item_G_Name";
            ddlitemgroup.DataSource = dt;
            ddlitemgroup.DataBind();
            ddlitemgroup.Items.Insert(0, new ListItem("--Select Item Group--", "-1"));
        }
    }
    public void binditemdetail()
    {
        string query = "SELECT sku,item_name,item_group_name,item_sale_rate,item_unit,('../' + Productimage) AS Productimage FROM Item_detail";
        SqlDataAdapter sda = new SqlDataAdapter(query, cl.con);
        DataTable dt = new DataTable();
        sda.Fill(dt);
        if (dt.Rows.Count > 0)
        {
            grid1.DataSource = dt;
            grid1.DataBind();
        }
    }
}