<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="Default" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Home</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />

    <!-- ADDED -->
    <link rel="stylesheet"
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />

    <style>
        body {
            margin: 0;
            font-family: Segoe UI;
            background: #f5f5f5;
            padding-bottom: 120px; /* ADDED */
        }

        /* Top */
        .topbar {
            background: #7a4a00;
            padding: 10px;
            color: white;
        }

        .searchbox {
            background: white;
            border-radius: 10px;
            padding: 8px 12px;
        }

        /* Banner */
        .banner {
            margin: 10px;
            border-radius: 14px;
            overflow: hidden;
        }

            .banner img {
                width: 100%;
                display: block;
            }

        /* price bubbles */
        .bubble-row {
            display: flex;
            gap: 10px;
            padding: 10px;
            overflow-x: auto;
        }

        .bubble {
            min-width: 80px;
            height: 80px;
            background: #c89100;
            border-radius: 50%;
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 13px;
            font-weight: 600;
        }

        /* offer cards */
        .offer-row {
            display: flex;
            gap: 12px;
            padding: 10px;
            overflow-x: auto;
        }

        .offer-card {
            min-width: 160px;
            background: #ffefb0;
            border-radius: 16px;
            text-align: center;
            padding: 10px;
        }

            .offer-card img {
                width: 100%;
                height: 110px;
                object-fit: contain;
            }

        /* frequently bought */

        .section-title {
            padding: 10px;
            font-size: 18px;
            font-weight: 600;
        }

        .product-row {
            display: flex;
            gap: 12px;
            padding: 10px;
            overflow-x: auto;
        }

        .product-card {
            min-width: 140px;
            background: white;
            border-radius: 16px;
            padding: 8px;
            box-shadow: 0 3px 8px rgba(0,0,0,.1);
        }

            .product-card img {
                width: 100%;
                height: 120px;
                object-fit: contain;
            }

        .price {
            font-weight: 600;
        }

        .old {
            text-decoration: line-through;
            color: gray;
            font-size: 12px;
        }

        /* bottom cart bar */
        .cart-bar {
            position: fixed;
            bottom: 60px;
            left: 10px;
            right: 10px;
            background: #4b1d73;
            color: white;
            padding: 12px;
            border-radius: 16px;
            display: flex;
            justify-content: space-between;
        }

        /* ========================= */
        /* ADDED : bottom navigation */
        /* ========================= */

        .bottom-nav {
            position: fixed;
            bottom: 0;
            left: 0;
            right: 0;
            height: 60px;
            background: #fff;
            border-top: 1px solid #ddd;
            display: flex;
            justify-content: space-around;
            align-items: center;
            z-index: 9999;
        }

            .bottom-nav a {
                text-decoration: none;
                color: #555;
                display: flex;
                flex-direction: column;
                align-items: center;
                font-size: 12px;
            }

                .bottom-nav a i {
                    font-size: 20px;
                    margin-bottom: 4px;
                }

                .bottom-nav a.active {
                    color: #6a1bb1;
                    font-weight: 600;
                }
    </style>
</head>
<body>
    <form runat="server">
        <div class="topbar">
            <div class="searchbox">
                <asp:TextBox ID="txtSearch" runat="server" Width="100%" BorderStyle="None"
                    placeholder="Search 'Snacks'"></asp:TextBox>
            </div>
        </div>
        <div class="banner">
            <asp:Image ID="imgBanner" runat="server" />
        </div>
        <div class="bubble-row">
            <asp:Repeater ID="rptPriceBubbles" runat="server">
                <ItemTemplate>
                    <div class="bubble">
                        <%# Eval("Title") %>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
        <div class="offer-row">
            <asp:Repeater ID="rptOffers" runat="server">
                <ItemTemplate>
                    <div class="offer-card">
                        <img src="<%# Eval("ImageUrl") %>" />
                        <div><%# Eval("Caption") %></div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
        <div class="section-title">Frequently Bought</div>
        <div class="product-row">
            <asp:Repeater ID="rptProducts" runat="server">
                <ItemTemplate>
                    <div class="product-card">
                        <img src="<%# Eval("ImageUrl") %>" />
                        <div><%# Eval("ProductName") %></div>
                        <div>
                            ₹ <%# Eval("Price") %>
                            <span class="old">₹ <%# Eval("OldPrice") %></span>
                        </div>
                        <asp:Button runat="server"
                            Text="ADD"
                            CssClass="addbtn"
                            CommandArgument='<%# Eval("ProductId") %>' />
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
        <div class="cart-bar">
            <div>
                Shop for ₹<asp:Label ID="lblMore" runat="server" Text="63"></asp:Label>
                more
            </div>
            <div>
                Cart (<asp:Label ID="lblItems" runat="server" Text="4"></asp:Label>)
            </div>
        </div>
        <div class="bottom-nav">
            <a href="Default.aspx" class="active">
                <i class="fa-solid fa-house"></i>
                <span>Home</span>
            </a>
            <a href="Categories.aspx">
                <i class="fa-solid fa-table-cells"></i>
                <span>Categories</span>
            </a>
            <a href="Orders.aspx">
                <i class="fa-solid fa-rotate-left"></i>
                <span>Order Again</span>
            </a>
            <a href="Cart.aspx">
                <i class="fa-solid fa-bag-shopping"></i>
                <span>My Bag</span>
            </a>
        </div>
    </form>
</body>
</html>
