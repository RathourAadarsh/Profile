<%@ Page Title="" Language="C#" MasterPageFile="~/BillingMaster.master" AutoEventWireup="true" CodeFile="Billing.aspx.cs" Inherits="Billing" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">

    <style>
  
    </style>
    <%--  <script>
        function printContent(el) {
            var restorepage = $('body').html();
            var printcontent = $('#' + el).clone();
            var enteredtext = $('#panel1').val();
            $('body').empty().html(printcontent);   
            window.print();
            $('body').html(restorepage);
            $('#panel1').html(enteredtext);
            $('body').html(restorepage);
        }
    </script>
    <script type="text/javascript">
        window.history.forward();
        function noBack() {
            window.history.forward();
        }
    </script>--%>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <main>
        <div class="container-fluid">
            <div class="row">
                <div class="col-md-12" style="box-shadow: 0px 1px 3px 1px #f9580e; border-radius: 5px; padding-top: 8px; padding-bottom: 8px;">
                    <div class="row" style="border-bottom: 1px solid red; padding-bottom: 4px;">
                        <div class="col-md-7">
                            <asp:TextBox runat="server" ID="txtnumber" Text="" ForeColor="Red" Font-Bold="true" class="form-control"
                                Height="35" placeholder="Search Product" AutoPostBack="true" OnTextChanged="txtnumber_TextChanged"></asp:TextBox>
                        </div>
                        <div class="col-md-2"></div>
                        <div class="col-md-3">
                            <div class="table-info">
                                <asp:HiddenField ID="hfTableNo" runat="server" />
                                <i class='fa-solid fa-utensils'></i>
                                <span>TABLE NO :</span>
                                <b>
                                    <asp:HiddenField ID="HiddenField1" runat="server" />
                                    <asp:Label ID="lblbillno" runat="server" Style="display: none" />
                                    <asp:Label ID="lblTableNo" runat="server"></asp:Label>
                                </b>
                            </div>
                            <asp:Button ID="Button1" runat="server" Text="Back" CssClass="btn-pos red" OnClick="Button1_Click" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-2 item-group-col">
                            <asp:Panel ID="pnldetail" runat="server" CssClass="item-panel">
                                <asp:ListView ID="lst" runat="server" DataKeyNames="item_g_id">
                                    <LayoutTemplate>
                                        <div class="item-group-header">
                                            ITEM GROUP
                                        </div>
                                        <ul class="item-group-list">
                                            <asp:PlaceHolder ID="itemPlaceHolder" runat="server" />
                                        </ul>
                                    </LayoutTemplate>
                                    <ItemTemplate>
                                        <li class="item-group-li">
                                            <asp:LinkButton
                                                ID="lnlroom"
                                                runat="server"
                                                Text='<%# Eval("item_g_name") %>'
                                                CssClass="item-group-link"
                                                OnClick="lnlroom_Click">
                                            </asp:LinkButton>
                                        </li>
                                    </ItemTemplate>
                                </asp:ListView>
                            </asp:Panel>
                        </div>
                        <div class="col-md-5 item-area">
                            <asp:Label runat="server" ID="lblmessage" CssClass="text-danger" Visible="false"></asp:Label>
                            <asp:Panel ID="Panel1" runat="server" CssClass="item-panel-right">
                                <asp:DataList
                                    ID="ListView1"
                                    runat="server"
                                    RepeatDirection="Horizontal"
                                    RepeatColumns="4"
                                    DataKeyField="item_name">
                                    <ItemTemplate>
                                        <div class="item-box">
                                            <asp:LinkButton
                                                ID="itemname"
                                                runat="server"
                                                Text='<%# Eval("item_name") %>'
                                                CssClass="item-btn"
                                                OnClick="itemname_Click"
                                                CommandName="ShowSubCats"
                                                CommandArgument='<%# Eval("item_name") %>'>
                                            </asp:LinkButton>
                                        </div>
                                    </ItemTemplate>
                                </asp:DataList>
                            </asp:Panel>
                        </div>
                        <div class="col-md-5 p-0">
                            <div class="bill-container">
                                <div class="bill-grid">
                                    <asp:GridView ID="gvBill" runat="server"
                                        AutoGenerateColumns="false"
                                        CssClass="pos-table"
                                        OnRowCommand="gvBill_RowCommand">
                                        <Columns>
                                            <asp:BoundField DataField="ItemName" HeaderText="ITEM" />
                                            <asp:BoundField DataField="Rate" HeaderText="RATE" />
                                            <asp:TemplateField HeaderText="QTY">
                                                <ItemTemplate>
                                                    <div class="pos-qty">
                                                        <asp:LinkButton runat="server"
                                                            CommandName="Minus"
                                                            CommandArgument='<%# Container.DataItemIndex %>'
                                                            CssClass="pos-btn minus">−</asp:LinkButton>
                                                        <span class="pos-value"><%# Eval("Qty") %></span>
                                                        <asp:LinkButton runat="server"
                                                            CommandName="Plus"
                                                            CommandArgument='<%# Container.DataItemIndex %>'
                                                            CssClass="pos-btn plus">+</asp:LinkButton>
                                                    </div>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:BoundField DataField="Amount" HeaderText="AMOUNT" />
                                            <asp:TemplateField>
                                                <ItemTemplate>
                                                    <asp:LinkButton runat="server"
                                                        CommandName="Remove"
                                                        CommandArgument='<%# Container.DataItemIndex %>'
                                                        CssClass="pos-remove">✕</asp:LinkButton>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                        </Columns>
                                    </asp:GridView>
                                </div>
                                <div id="billSummary" class="bill-summary">
                                    <div class="bill-row">
                                        <span>Sub Total</span><b>₹
                                        <asp:Label ID="lblSubTotal" runat="server" /></b>
                                    </div>
                                    <div class="bill-row">
                                        <span>Discount</span><b>₹ 
                                            <asp:TextBox ID="txtdiscount"
                                                runat="server"
                                                CssClass="form-control text-end"
                                                Style="width: 80px; display: inline-block; height: 30px;"
                                                AutoPostBack="true"
                                                OnTextChanged="txtdiscount_TextChanged" Text="0.00" /></b>
                                    </div>
                                    <div class="bill-row">
                                        <span>Delivery Charge</span><b>₹ 
                                            <asp:TextBox ID="txtdilivery"
                                                runat="server"
                                                CssClass="form-control text-end"
                                                Style="width: 80px; display: inline-block; height: 30px;"
                                                AutoPostBack="true"
                                                OnTextChanged="txtdilivery_TextChanged" Text="0.00" /></b>
                                    </div>
                                    <div class="bill-row">
                                        <span>Tax</span><b>₹
                                        <asp:Label ID="lblTax" runat="server" /></b>
                                    </div>
                                    <div class="bill-row">
                                        <span>Round Off</span><b>₹
                                        <asp:Label ID="lblRoundOff" runat="server" /></b>
                                    </div>
                                    <div class="bill-row">
                                        <span>Customer Paid</span><b>₹ 
                                            <asp:TextBox ID="txtCustomerPaid"
                                                runat="server"
                                                CssClass="form-control text-end"
                                                Style="width: 80px; display: inline-block; height: 30px;"
                                                AutoPostBack="true"
                                                OnTextChanged="txtCustomerPaid_TextChanged" Text="0.00" /></b>
                                    </div>
                                    <div class="bill-row total">
                                        <span>Return to Customer</span><b>₹
                                        <asp:Label ID="lblReturn" runat="server" /></b>
                                    </div>
                                </div>
                                <div class="bill-toggle" onclick="toggleBillSummary()">
                                    <span>Bill Summary</span>
                                    <i id="billArrow" class="fa-solid fa-chevron-up"></i>
                                </div>
                            </div>
                            <div class="pos-footer">
                                <div class="pos-row pos-row-top">
                                    <div class="pos-left">
                                        <button class="pos-chip offer btn-pos red">Bogo Offer</button>
                                        <button class="pos-chip split btn-pos red">Split</button>
                                    </div>

                                    <div class="pos-total-line">
                                        Total : ₹ 
                                        <asp:Label ID="lblGrandTotal" runat="server"></asp:Label>
                                    </div>
                                </div>
                                <div class="pos-row pos-pay-boxes">

                                    <label class="pay-box">
                                        <asp:RadioButton ID="rbCash" runat="server" GroupName="pay" Checked="true" />
                                        <i class="fa-solid fa-money-bill-wave"></i>
                                        <span>Cash</span>
                                    </label>

                                    <label class="pay-box">
                                        <asp:RadioButton ID="rbCard" runat="server" GroupName="pay" />
                                        <i class="fa-solid fa-credit-card"></i>
                                        <span>Card</span>
                                    </label>

                                    <label class="pay-box">
                                        <asp:RadioButton ID="rbUPI" runat="server" GroupName="pay" />
                                        <i class="fa-solid fa-mobile-screen-button"></i>
                                        <span>UPI</span>
                                    </label>

                                    <label class="pay-box">
                                        <asp:RadioButton ID="rbOther" runat="server" GroupName="pay" />
                                        <i class="fa-solid fa-ellipsis"></i>
                                        <span>Other</span>
                                    </label>
                                </div>
                                <div class="pos-row pos-paid">
                                    <label>
                                        <asp:CheckBox ID="chkPaid" runat="server" />
                                        It's Paid
                                    </label>
                                </div>
                                <div class="pos-actions">
                                    <asp:Button ID="btnKot" runat="server" Text="Save KOT" CssClass="btn-pos dark" OnClick="btnKot_Click" />
                                    <asp:Button ID="btnKotPrint" runat="server" Text="Save KOT & Print" CssClass="btn-pos dark" OnClick="btnKotPrint_Click" />
                                    <asp:Button ID="btnSave" runat="server" Text="Save Bill" CssClass="btn-pos red" OnClick="btnSave_Click" />
                                    <asp:Button ID="btnSavePrint" runat="server" Text="Bill Save & Print" CssClass="btn-pos red" OnClick="btnSavePrint_Click" />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
    <script>
        function printBill() {
            var printContents = document.getElementById("<%= gvBill.ClientID %>").outerHTML;
            var originalContents = document.body.innerHTML;

            document.body.innerHTML =
                "<h3 style='text-align:center'>KOT / BILL</h3>" +
                printContents;

            window.print();
            document.body.innerHTML = originalContents;
            location.reload();
        }
    </script>
    <script>
        function toggleBillSummary() {
            var panel = document.getElementById("billSummary");
            var arrow = document.getElementById("billArrow");

            panel.classList.toggle("open");
            arrow.classList.toggle("rotate");
        }
    </script>
</asp:Content>

