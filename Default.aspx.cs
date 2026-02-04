using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

public partial class Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        LoadBanner();
        LoadPriceBubbles();
        LoadOffers();
        LoadProducts();
    }
    void LoadBanner()
    {
        imgBanner.ImageUrl = "images/mega.jpg";   // Mega Value banner
    }

    void LoadPriceBubbles()
    {
        DataTable dt = new DataTable();
        dt.Columns.Add("Title");

        dt.Rows.Add("Under ₹99");
        dt.Rows.Add("Under ₹299");
        dt.Rows.Add("Under ₹499");
        dt.Rows.Add("Under ₹699");

        rptPriceBubbles.DataSource = dt;
        rptPriceBubbles.DataBind();
    }

    void LoadOffers()
    {
        DataTable dt = new DataTable();
        dt.Columns.Add("ImageUrl");
        dt.Columns.Add("Caption");

        dt.Rows.Add("images/o1.png", "Under ₹699");
        dt.Rows.Add("images/o2.png", "Up to 80%");

        rptOffers.DataSource = dt;
        rptOffers.DataBind();
    }

    void LoadProducts()
    {
        DataTable dt = new DataTable();

        dt.Columns.Add("ProductId");
        dt.Columns.Add("ProductName");
        dt.Columns.Add("Price");
        dt.Columns.Add("OldPrice");
        dt.Columns.Add("ImageUrl");

        dt.Rows.Add(1, "HIT SQUARE Gym Vest", 139, 399, "images/p1.png");
        dt.Rows.Add(2, "HIT SQUARE Gym Vest", 139, 399, "images/p2.png");
        dt.Rows.Add(3, "HIT SQUARE Gym Vest", 139, 399, "images/p3.png");

        rptProducts.DataSource = dt;
        rptProducts.DataBind();
    }
}