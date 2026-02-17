<%@ Page Title="" Language="C#" MasterPageFile="./MasterPage.master" AutoEventWireup="true" CodeFile="Bill.aspx.cs" Inherits="Bill" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

    <style>
        @media (min-width: 576px) {
            .modal-dialog {
                max-width: 80%;
                margin: 1.75rem auto;
            }
        }

        th {
            height: 40px !important;
        }

        .custom-font-size {
            font-size: 16px;
        }

        .swal-footer {
            text-align: center !important;
        }

        .swal-text {
            font-size: 22px !important;
            text-align: center;
        }

        .swal-button {
            background-color: #184f34 !important;
        }
    </style>
    <link href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script type="text/javascript" src="sweetalertnew.js"></script>
    <script type="text/javascript">
        function savealert(message, type) {
            swal({
                text: message,
                icon: type === 'success' ? 'success' : type === 'info' ? 'info' : type === 'error' ? 'error' : 'warning',
            });
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:ScriptManager runat="server"></asp:ScriptManager>
    <main>
        <div class="container-fluid p-4">
            <div class="row">
                <div class="col-md-12" style="border: 1px solid #ced4da; margin-top: 65px;">
                    <div class="form-group">
                        <div class="row" style="margin-top: 12px;">
                            <div class="col-md-10" style="text-align: center;">
                                <h4 style="font-weight: 600; color: black;">BILL</h4>
                            </div>
                            <div class="col-md-2" style="text-align: right;">
                                <a href="ProductMaster.aspx" class="btn btn-info">Add New</a>
                            </div>
                        </div>
                        <hr />
                    </div>
                    <div class="form-group">
                        <div class="row">
                            <div class="col-md-8">
                                <div class="form-group mb-0">
                                    <div class="row">
                                        <div class="col-md-2">
                                            <asp:Label ID="Label7" Text="Bar Code" runat="server" ForeColor="Black"></asp:Label>
                                            <asp:TextBox runat="server" ID="txtitemcode" class="form-control" OnTextChanged="txtitemcode_TextChanged" AutoPostBack="true" Style="padding-left: 2px;" Font-Size="14px"></asp:TextBox>
                                        </div>
                                        <div class="col-md-3 p-0">
                                            <asp:Label ID="Label5" Text="Item Name" runat="server" ForeColor="Black"></asp:Label>
                                            <%-- <asp:DropDownList runat="server" ID="ddlitenme" class="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddlitenme_SelectedIndexChanged"></asp:DropDownList>--%>
                                            <asp:TextBox runat="server" Class="form-control" ID="txtitem"></asp:TextBox>
                                            <asp:TextBox runat="server" Class="form-control" ID="txtcloth" Style="display: none;"></asp:TextBox>

                                        </div>
                                        <div class="col-md-1 pr-0">
                                            <asp:Label ID="Label6" Text="GST %" runat="server" ForeColor="Black"></asp:Label>
                                            <asp:TextBox runat="server" ID="txtgst" class="form-control" Text="0"></asp:TextBox>
                                        </div>
                                        <div class="col-md-1">
                                            <asp:Label ID="Label9" Text="Qty" runat="server" ForeColor="Black"></asp:Label>
                                            <asp:TextBox runat="server" ID="txtqty" class="form-control" Text="1" onchange="onqtychange();"></asp:TextBox>

                                        </div>
                                        <div class="col-md-1 p-0">
                                            <asp:Label ID="lbldiss" Text="Dis.%" runat="server" ForeColor="Black"></asp:Label>
                                            <asp:TextBox runat="server" ID="txtdisss" class="form-control" onchange="onqtychange(true)"></asp:TextBox>
                                        </div>
                                        <div class="col-md-1 pr-0">
                                            <asp:Label ID="lblq1" Text="D. amt" runat="server" ForeColor="Black"></asp:Label>
                                            <asp:TextBox runat="server" ID="txtdiscout" class="form-control p-1" onchange="onqtychange(false)"></asp:TextBox>
                                        </div>
                                        <div class="col-md-1 pr-0">
                                            <asp:Label ID="Label10" Text="Rate" runat="server" ForeColor="Black"></asp:Label>
                                            <asp:TextBox runat="server" ID="txtrate" class="form-control p-0" onchange="ratechange();"></asp:TextBox>
                                        </div>
                                        <div class="col-md-1 pr-0">
                                            <asp:Label ID="Label12" Text="Amount" runat="server" ForeColor="Black"></asp:Label>
                                            <asp:TextBox runat="server" ID="txtamt" class="form-control p-0"></asp:TextBox>
                                        </div>
                                        <div class="col-md-1" style="margin-top: 23px;">
                                            <asp:Button Text="Add" ID="Button2" runat="server" class="btn btn-success" OnClick="btnAddData12_Click"></asp:Button>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group mb-0">
                                    <div class="row">
                                        <div class="col-md-5"></div>
                                        <div class="col-md-4">
                                            <asp:Label ID="lblqty1" runat="server" ForeColor="red" Font-Size="10"></asp:Label>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <div class="row" style="margin-top: 7px">
                                        <div class="col-md-12 p-0" style="border: solid 1px #ccc; overflow: scroll; height: 250px;">
                                            <asp:GridView runat="server" ID="gridview1" AutoGenerateColumns="False" CellPadding="4" ForeColor="#333333" GridLines="None" Width="100%" ShowFooter="false" OnRowDataBound="gridview1_RowDataBound">
                                                <AlternatingRowStyle BackColor="White" />
                                                <Columns>
                                                    <asp:TemplateField HeaderText="Bill No.">
                                                        <ItemTemplate>
                                                            <asp:Label runat="server" ID="lblbillno" Text='<%#Eval("Billno")%>'></asp:Label>
                                                            <asp:Label runat="server" ID="lblid" Text='<%#Eval("id")%>' Visible="false"></asp:Label>
                                                        </ItemTemplate>
                                                        <FooterTemplate>
                                                        </FooterTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Bar Code">
                                                        <ItemTemplate>
                                                            <asp:Label runat="server" ID="lblitemcode" Text='<%#Eval("Itemcode")%>'></asp:Label>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Item Description">
                                                        <ItemTemplate>
                                                            <asp:Label runat="server" ID="lblitemname" Text='<%#Eval("Itemname")%>'></asp:Label>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="GST %">
                                                        <ItemTemplate>
                                                            <asp:Label runat="server" ID="lblgst" Text='<%#Eval("gst")%>'></asp:Label>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="D. %">
                                                        <ItemTemplate>
                                                            <asp:Label runat="server" ID="lbldis1" Text='<%#Eval("discountper")%>'></asp:Label>
                                                        </ItemTemplate>
                                                        <FooterTemplate>
                                                            <asp:Label runat="server" ID="lblTotalDiscount" Text="0.00" Visible="false"></asp:Label>
                                                        </FooterTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="D. amt">
                                                        <ItemTemplate>
                                                            <asp:Label runat="server" ID="lbldisamt" Text='<%#Eval("disamt")%>'></asp:Label>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Qty">
                                                        <ItemTemplate>
                                                            <asp:Label runat="server" ID="lblqty" Text='<%#Eval("qty")%>'></asp:Label>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Price">
                                                        <ItemTemplate>
                                                            <asp:Label runat="server" ID="lblsaleprice" Text='<%#Eval("rate")%>'></asp:Label>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Amount">
                                                        <ItemTemplate>
                                                            <asp:Label runat="server" ID="lblamt" Text='<%#Eval("amt")%>'></asp:Label>
                                                        </ItemTemplate>
                                                        <ItemStyle HorizontalAlign="Right" />
                                                        <HeaderStyle HorizontalAlign="Right" />
                                                        <FooterTemplate>
                                                            <asp:Label runat="server" ID="lblTotalAmount" Text="0.00" Font-Bold="True" Visible="false"></asp:Label>
                                                            <asp:Label ID="lblCGST" runat="server" Text="0.00" Visible="false"></asp:Label>
                                                            <asp:Label ID="lblSGST" runat="server" Text="0.00" Visible="false"></asp:Label>
                                                            <asp:Label ID="lblSubtotal" runat="server" Text="0.00" Visible="false"></asp:Label>
                                                            <asp:Label ID="lblTotal" runat="server" Text="0.00" Visible="false"></asp:Label>
                                                        </FooterTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Edit">
                                                        <ItemTemplate>
                                                            <asp:ImageButton runat="server" ID="lbledit" src="Resources/edit.png" Style="height: 15px; width: 20px;" OnClick="lbledit_Click"></asp:ImageButton>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                </Columns>
                                                <FooterStyle BackColor="#ca1763" Font-Bold="True" ForeColor="White" />
                                                <HeaderStyle BackColor="#ca1763" Font-Bold="True" ForeColor="White" Height="40px" />
                                                <PagerStyle BackColor="#FFCC66" ForeColor="#333333" HorizontalAlign="Center" />
                                                <RowStyle BackColor="#FFFBD6" ForeColor="#333333" />
                                                <SelectedRowStyle BackColor="#FFCC66" Font-Bold="True" ForeColor="Navy" />
                                                <SortedAscendingCellStyle BackColor="#FDF5AC" />
                                                <SortedAscendingHeaderStyle BackColor="#4D0000" />
                                                <SortedDescendingCellStyle BackColor="#FCF6C0" />
                                                <SortedDescendingHeaderStyle BackColor="#820000" />
                                            </asp:GridView>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group mb-0">
                                    <div class="row">
                                        <div class="col-md-4">
                                            <asp:Literal ID="ltTable" runat="server"></asp:Literal>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="row p-1">
                                                <div class="col-md-12 p-2" style="border: 1px solid #ced4da; border-radius: 15px; box-shadow: 1px 4px 5px 2px;">
                                                    <div class="row" style="display: none;">
                                                        <div class="col-md-12">
                                                            <asp:TextBox runat="server" CssClass="form-control" ID="txtpid" ReadOnly="true"></asp:TextBox>
                                                            <asp:Label runat="server" ID="txtid" Visible="false"></asp:Label>
                                                        </div>
                                                    </div>
                                                    <div>No. of Item : <span id="lblItemCount" runat="server"></span></div>
                                                    <div class="row mt-2">
                                                        <div class="col-md-2 pr-0">
                                                            <asp:Label ID="Label2" Text="Bill No. :" runat="server" ForeColor="Black" Font-Size="15px" Font-Bold="true"></asp:Label>
                                                        </div>
                                                        <div class="col-md-4">
                                                            <asp:Label runat="server" ID="lblbillno1" ForeColor="Black" Font-Size="15px"></asp:Label>
                                                            <asp:Label runat="server" ID="lblbillno1c" ForeColor="Black" Font-Size="15px" Style="display: none;"></asp:Label>
                                                        </div>
                                                        <div class="col-md-3">
                                                            <asp:Label ID="Label3" Text="Bill Date :" runat="server" ForeColor="Black" Font-Size="15px" Font-Bold="true"></asp:Label>
                                                        </div>
                                                        <div class="col-md-3">
                                                            <asp:Label runat="server" ID="txtbilldate" TextMode="Date" ForeColor="Black" Font-Size="15px"></asp:Label>
                                                        </div>
                                                    </div>
                                                    <div class="row" style="margin-top: 23px;">
                                                        <div class="col-md-3">
                                                            <asp:Label ID="Label4" Text="Sub Total :" runat="server" ForeColor="Black" Font-Size="15px" Font-Bold="true"></asp:Label>
                                                        </div>
                                                        <div class="col-md-3">
                                                            <asp:Label runat="server" ID="txtbillamt" ForeColor="Black" Font-Size="15px"></asp:Label>
                                                        </div>
                                                        <div class="col-md-3 pr-0">
                                                            <asp:Label ID="Label" Text="Discount Amt :" runat="server" ForeColor="Black" Font-Size="15px" Font-Bold="true"></asp:Label>
                                                        </div>
                                                        <div class="col-md-3">
                                                            <asp:Label runat="server" ID="lbldis" TextMode="Date" ForeColor="Black" Font-Size="15px"></asp:Label>
                                                        </div>
                                                    </div>
                                                    <div class="row" style="margin-top: 23px; margin-bottom: 5px">
                                                        <div class="col-md-3">
                                                            <asp:Label ID="Label11" Text="CGST Amt :" runat="server" ForeColor="Black" Font-Size="15px" Font-Bold="true"></asp:Label>
                                                        </div>
                                                        <div class="col-md-3">
                                                            <asp:Label runat="server" ID="lblcgst" TextMode="Date" ForeColor="Black" Font-Size="15px"></asp:Label>
                                                        </div>
                                                        <div class="col-md-3">
                                                            <asp:Label ID="Label14" Text="SGST Amt :" runat="server" ForeColor="Black" Font-Size="15px" Font-Bold="true"></asp:Label>
                                                        </div>
                                                        <div class="col-md-3">
                                                            <asp:Label runat="server" ID="lblsgst" ForeColor="Black" Font-Size="15px"></asp:Label>
                                                        </div>
                                                    </div>
                                                    <div class="row" style="margin-top: 23px;">
                                                        <div class="col-md-3 pr-0">
                                                            <asp:Label ID="Label1" Text="Bill Amt :" runat="server" ForeColor="Red" Font-Size="20px" Font-Bold="true"></asp:Label>
                                                        </div>
                                                        <div class="col-md-3">
                                                            <asp:Label runat="server" ID="lbltotal" ForeColor="red" Font-Size="20px"></asp:Label>
                                                        </div>
                                                        <div class="col-md-6 p-0">
                                                            <asp:Button ID="btnHold" runat="server" Text="Hold Bill" CssClass="btn btn-warning" OnClick="btnHold_Click" />
                                                            <asp:Button ID="btnFinalize" runat="server" Text="Clear Hold Bill" CssClass="btn btn-success" OnClick="btnFinalize_Click" />
                                                            <!-- Modal -->
                                                            <div class="modal fade" id="HoldBillModal" tabindex="-1" role="dialog" aria-labelledby="HoldBillLabel">
                                                                <div class="modal-dialog modal-lg" role="document">
                                                                    <div class="modal-content">
                                                                        <div class="modal-header">
                                                                            <h5 class="modal-title" id="HoldBillLabel">Hold Bill List</h5>
                                                                            <button type="button" class="close" data-dismiss="modal">&times;</button>
                                                                        </div>
                                                                        <div class="modal-body">
                                                                            <asp:GridView ID="gvHoldBills" runat="server" CssClass="table table-bordered table-striped" AutoGenerateColumns="False" OnRowCommand="gvHoldBills_RowCommand">
                                                                                <Columns>
                                                                                    <asp:TemplateField HeaderText="Bill No">
                                                                                        <ItemTemplate>
                                                                                            <asp:LinkButton ID="lnkBillNo" runat="server"
                                                                                                CommandName="SelectBill"
                                                                                                CommandArgument='<%# Eval("BillNo") %>'
                                                                                                Text='<%# Eval("BillNo") %>' CssClass="btn btn-link"></asp:LinkButton>
                                                                                        </ItemTemplate>
                                                                                    </asp:TemplateField>
                                                                                    <asp:BoundField DataField="ItemName" HeaderText="Item Name" />
                                                                                    <asp:BoundField DataField="Qty" HeaderText="Qty" />
                                                                                    <asp:BoundField DataField="Rate" HeaderText="Rate" />
                                                                                    <asp:BoundField DataField="Amt" HeaderText="Amount" />
                                                                                </Columns>
                                                                            </asp:GridView>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="row p-1">
                                                <div class="col-md-12" style="border: 1px solid #ced4da; border-radius: 15px; box-shadow: 1px 4px 5px 2px;">
                                                    <div class="row mt-3 mb-2">
                                                        <div class="col-md-5">
                                                            <input type="checkbox" id="myCheckbox1" />
                                                            <label for="myCheckbox">Add New Party</label>
                                                        </div>
                                                        <div class="col-md-4">
                                                            <h6>Gstin Sale</h6>
                                                        </div>
                                                    </div>
                                                    <div class="row">
                                                        <div class="col-md-2 p-0" style="text-align: center">
                                                            <asp:Label ID="Label8" Text="Mob. No." runat="server" ForeColor="Black"></asp:Label>
                                                            <div style="display: none">
                                                                <asp:TextBox runat="server" CssClass="form-control" ID="autid"></asp:TextBox>
                                                            </div>
                                                        </div>
                                                        <div class="col-md-4" style="margin-bottom: 10px">
                                                            <asp:TextBox runat="server" ID="txtmobile" class="form-control" OnTextChanged="txtmobile_TextChanged" AutoPostBack="true" onkeyup="checkMobileNumber()"></asp:TextBox>
                                                        </div>
                                                        <div class="col-md-2">
                                                            <asp:Label ID="lb" Text="Name" runat="server" ForeColor="Black"></asp:Label>
                                                        </div>
                                                        <div class="col-md-4">
                                                            <asp:TextBox runat="server" ID="txtname" class="form-control"></asp:TextBox>
                                                        </div>
                                                    </div>
                                                    <div class="row">
                                                        <div class="col-md-2 p-0" style="text-align: center">
                                                            <asp:Label ID="Label15" Text="GST No." runat="server" ForeColor="Black"></asp:Label>
                                                        </div>
                                                        <div class="col-md-4">
                                                            <asp:TextBox runat="server" ID="txtgstn" class="form-control"></asp:TextBox>
                                                        </div>
                                                        <div class="col-md-2">
                                                            <asp:Label ID="Label13" Text="Address" runat="server" ForeColor="Black"></asp:Label>
                                                        </div>
                                                        <div class="col-md-4">
                                                            <asp:TextBox runat="server" ID="txtadd" class="form-control" TextMode="MultiLine"></asp:TextBox>
                                                        </div>
                                                    </div>
                                                    <div class="row mb-3">
                                                        <div class="col-md-12">
                                                            <div>
                                                                <button type="button" class="btn btn-info" id="myCheckbox2" onclick="">Continue</button>
                                                                <asp:Button Text="Close" runat="server" ID="btnclose" OnClick="btnclose_Click" CssClass="btn btn-danger" />
                                                            </div>
                                                            <div class="modal fade" id="popupModal1" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
                                                                <div class="modal-dialog" role="document">
                                                                    <div class="modal-content" style="height: 500px;">
                                                                        <div class="modal-header">
                                                                            <h4 class="modal-title" style="text-align: center">Sale Bill Confirmation</h4>
                                                                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                                                                <span aria-hidden="true">&times;</span>
                                                                            </button>
                                                                        </div>
                                                                        <div class="modal-body" style="padding-bottom: 0px">
                                                                            <div class="row">
                                                                                <div class="col-md-6" style="border-right: 1px solid #ced4da;">
                                                                                    <div class="row">
                                                                                        <div class="col-md-4">
                                                                                            <div class="row">
                                                                                                <div class="col-md-12">
                                                                                                    <h5 style="margin-bottom: 10px;">Sale Type</h5>
                                                                                                    <asp:RadioButtonList ID="rblOptions" runat="server">
                                                                                                        <asp:ListItem Text="Cash Sale" Value="1" Selected="true" style="font-size: 16px; color: black"></asp:ListItem>
                                                                                                        <asp:ListItem Text="Member sale" Value="2" style="font-size: 16px; color: black"></asp:ListItem>
                                                                                                        <asp:ListItem Text="Card Sale" Value="3" style="font-size: 16px; color: black"></asp:ListItem>
                                                                                                        <asp:ListItem Text="Credit Note Sale" Value="4" style="font-size: 16px; color: black; display: none"></asp:ListItem>
                                                                                                        <asp:ListItem Text="GSTIN Bill" Value="5" style="font-size: 16px; color: black"></asp:ListItem>
                                                                                                        <asp:ListItem Text="UPI Sale" Value="6" style="font-size: 16px; color: black"></asp:ListItem>
                                                                                                        <asp:ListItem Text="Sudaskho Sale" Value="7" style="font-size: 16px; color: black; display: none"></asp:ListItem>

                                                                                                    </asp:RadioButtonList>
                                                                                                </div>
                                                                                            </div>
                                                                                        </div>
                                                                                        <div class="col-md-8" style="margin-top: 40px;">
                                                                                            <div class="row">
                                                                                                <div class="col-md-4">
                                                                                                    <asp:Label runat="server" Text="Party Name"></asp:Label>
                                                                                                </div>
                                                                                                <div class="col-md-8">
                                                                                                    <asp:TextBox runat="server" ID="txtparty" CssClass="form-control"></asp:TextBox>
                                                                                                </div>
                                                                                                <div class="col-md-4 mt-1">
                                                                                                    <asp:Label runat="server" Text="Mobile No."></asp:Label>
                                                                                                </div>
                                                                                                <div class="col-md-8 mt-1">
                                                                                                    <asp:TextBox runat="server" ID="txtmno" CssClass="form-control"></asp:TextBox>
                                                                                                </div>
                                                                                                <div class="col-md-4 mt-1">
                                                                                                    <asp:Label runat="server" Text="Email"></asp:Label>
                                                                                                </div>
                                                                                                <div class="col-md-8 mt-1">
                                                                                                    <asp:TextBox runat="server" ID="txtemail" CssClass="form-control"></asp:TextBox>
                                                                                                </div>
                                                                                                <div class="col-md-4 mt-1">
                                                                                                    <asp:Label runat="server" Text="DOB"></asp:Label>
                                                                                                </div>
                                                                                                <div class="col-md-8 mt-1">
                                                                                                    <asp:TextBox runat="server" ID="txtdob" CssClass="form-control" TextMode="Date"></asp:TextBox>
                                                                                                </div>
                                                                                                <div class="col-md-4 mt-1 pr-0">
                                                                                                    <asp:Label runat="server" Text="Wedding Date"></asp:Label>
                                                                                                </div>
                                                                                                <div class="col-md-8 mt-1">
                                                                                                    <asp:TextBox runat="server" ID="txtannievr" CssClass="form-control" TextMode="Date"></asp:TextBox>
                                                                                                </div>
                                                                                            </div>
                                                                                            <div class="row mt-1" id="cardRow" style="display: none;">
                                                                                                <div class="col-md-4">
                                                                                                    <asp:Label runat="server" Text="Card No." Font-Size="14px" ForeColor="Black"></asp:Label>
                                                                                                </div>
                                                                                                <div class="col-md-8">
                                                                                                    <asp:TextBox runat="server" ID="txtcardno" class="form-control" Height="28px"></asp:TextBox>
                                                                                                </div>
                                                                                            </div>
                                                                                            <div class="row" style="margin-top: 36px; display: none;" id="typeRow12">
                                                                                                <div class="col-md-2">
                                                                                                    <asp:Label runat="server" Text="Type" Font-Size="14px" ForeColor="Black"></asp:Label>
                                                                                                </div>
                                                                                                <div class="col-md-4">
                                                                                                    <asp:TextBox runat="server" ID="txttype" class="form-control" Height="28px"></asp:TextBox>
                                                                                                </div>
                                                                                                <div class="col-md-1">
                                                                                                    <asp:Label runat="server" Text="No." Font-Size="14px" ForeColor="Black"></asp:Label>
                                                                                                </div>
                                                                                                <div class="col-md-5">
                                                                                                    <asp:TextBox runat="server" ID="txtno1" class="form-control" Height="28px"></asp:TextBox>
                                                                                                </div>
                                                                                            </div>
                                                                                            <div class="row" style="margin-top: 70px; display: none;" id="cradit">
                                                                                                <div class="col-md-4">
                                                                                                    <asp:Label runat="server" Text="No." Font-Size="14px" ForeColor="Black"></asp:Label>
                                                                                                </div>
                                                                                                <div class="col-md-8">
                                                                                                    <asp:TextBox runat="server" ID="txtno2" class="form-control" Height="28px"
                                                                                                        OnTextChanged="txtno2_TextChanged" AutoPostBack="true">
                                                                                                    </asp:TextBox>
                                                                                                </div>
                                                                                            </div>
                                                                                            <div id="ingst">
                                                                                                <div class="row" style="margin-top: 16px;">
                                                                                                    <div class="col-md-4">
                                                                                                        <asp:Label runat="server" Text="Name :" Font-Size="14px" ForeColor="Black"></asp:Label>
                                                                                                    </div>
                                                                                                    <div class="col-md-8">
                                                                                                        <asp:TextBox runat="server" ID="txtname1" class="form-control" Height="28px"></asp:TextBox>
                                                                                                    </div>
                                                                                                </div>
                                                                                                <div class="row" style="margin-top: 4px;">
                                                                                                    <div class="col-md-4">
                                                                                                        <asp:Label runat="server" Text="Address :" Font-Size="14px" ForeColor="Black"></asp:Label>
                                                                                                    </div>
                                                                                                    <div class="col-md-8">
                                                                                                        <asp:TextBox runat="server" ID="txtaddress" class="form-control" Height="28px" TextMode="MultiLine" Rows="2"></asp:TextBox>
                                                                                                    </div>
                                                                                                </div>
                                                                                            </div>
                                                                                            <div class="row" style="margin-top: 130px; display: none;" id="tyt">
                                                                                                <div class="col-md-5" style="display: none">
                                                                                                    <asp:Label runat="server" Text="Enter UPI :" Font-Size="14px" ForeColor="Black"></asp:Label>
                                                                                                </div>
                                                                                                <div class="col-md-7" style="display: none">
                                                                                                    <asp:TextBox runat="server" ID="txtupi" class="form-control" Height="28px"></asp:TextBox>
                                                                                                </div>
                                                                                            </div>
                                                                                        </div>
                                                                                    </div>
                                                                                </div>
                                                                                <div class="col-md-6">
                                                                                    <div class="row" style="margin-top: 5px;">
                                                                                        <div class="col-md-4">
                                                                                            <asp:Label runat="server" Text="Sub Total:" ID="labal7" ForeColor="Black"></asp:Label>
                                                                                        </div>
                                                                                        <div class="col-md-5">
                                                                                            <asp:TextBox runat="server" ID="subtotal" ForeColor="Black" Class="form-control"></asp:TextBox>
                                                                                        </div>
                                                                                    </div>
                                                                                    <div class="row" style="margin-top: 5px;">
                                                                                        <div class="col-md-4">
                                                                                            <asp:Label runat="server" Text="CGST %" ID="Label20" ForeColor="Black"></asp:Label>
                                                                                        </div>
                                                                                        <div class="col-md-5">
                                                                                            <asp:TextBox runat="server" ID="lblCGst1" ForeColor="Black" Class="form-control"></asp:TextBox>
                                                                                        </div>
                                                                                    </div>
                                                                                    <div class="row" style="margin-top: 5px;">
                                                                                        <div class="col-md-4">
                                                                                            <asp:Label runat="server" Text="SGST %" ID="Label22" ForeColor="Black"></asp:Label>
                                                                                        </div>
                                                                                        <div class="col-md-5">
                                                                                            <asp:TextBox runat="server" ID="Label23" ForeColor="Black" Class="form-control"></asp:TextBox>
                                                                                        </div>
                                                                                    </div>
                                                                                    <div class="row" style="margin-top: 5px;">
                                                                                        <div class="col-md-4">
                                                                                            <asp:Label runat="server" Text="Discount Rs :" ID="Label18" ForeColor="Black"></asp:Label>
                                                                                        </div>
                                                                                        <div class="col-md-5">
                                                                                            <asp:TextBox runat="server" Class="form-control" ID="txtdis" onchange="ondischange();" ForeColor="Black" ReadOnly="true"></asp:TextBox>
                                                                                        </div>
                                                                                    </div>
                                                                                    <div class="row" style="margin-top: 5px;">
                                                                                        <div class="col-md-4">
                                                                                            <asp:Label runat="server" Text="Additional Dis. Rs :" ID="Label187" ForeColor="Black"></asp:Label>
                                                                                        </div>
                                                                                        <div class="col-md-5">
                                                                                            <asp:TextBox runat="server" Class="form-control" ID="txtadddis" onchange="ondischange();" ForeColor="Black" Text="0.00"></asp:TextBox>
                                                                                        </div>
                                                                                    </div>
                                                                                    <div class="row" style="margin-top: 5px;">
                                                                                        <div class="col-md-4">
                                                                                            <asp:Label runat="server" Text="Final Total" ID="Label24" ForeColor="Black"></asp:Label>
                                                                                        </div>

                                                                                        <div class="col-md-5">
                                                                                            <asp:TextBox runat="server" ID="Label25" ForeColor="Black" Class="form-control"></asp:TextBox>
                                                                                        </div>
                                                                                    </div>
                                                                                    <div class="row" style="margin-top: 5px;">
                                                                                        <div class="col-md-4">
                                                                                            <asp:Label runat="server" Text="Tend" ID="Label26" ForeColor="Black"></asp:Label>
                                                                                        </div>
                                                                                        <div class="col-md-5">
                                                                                            <asp:TextBox runat="server" Class="form-control" ID="txttend" onchange="ontendchan();" ForeColor="Black"></asp:TextBox>
                                                                                        </div>
                                                                                    </div>
                                                                                    <div class="row" style="margin-top: 5px;">
                                                                                        <div class="col-md-4">
                                                                                            <asp:Label runat="server" Text="Balance" ID="Label28" ForeColor="Black"></asp:Label>
                                                                                        </div>
                                                                                        <div class="col-md-5">
                                                                                            <asp:TextBox runat="server" CssClass="form-control" ID="TextBox10" ForeColor="Black" onchange="ontendchan();"></asp:TextBox>
                                                                                        </div>
                                                                                    </div>
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                        <div class="modal-footer">
                                                                            <input type="button" id="btnsubmit2" value="Save" onclick="saveData()" class="btn btn-info" style="background-color: deepskyblue; height: 40px; width: 70px; color: white; border: none;" />
                                                                            <button type="button" onclick="printDiv();" class="btn btn-info" id="btnprint" data-dismiss="modal" style="display: none;">Print</button>
                                                                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-12">
                                        <div id="printArea" style="display: none;">
                                            <div class="row">
                                                <div class="col-md-12">
                                                    <div style="text-align: center">
                                                        <span id="printTitleSpan"></span>
                                                    </div>
                                                    <div style="text-align: center;">
                                                        <i style="font-size: 29px; display: inline-block; margin-bottom: -12px;">Delight Style</i>
                                                    </div>
                                                    <p style="text-align: center; margin-bottom: -9px; font-size: 10px;">Leaders in Comfort & Style</p>
                                                    <p style="text-align: center; margin-bottom: -9px; font-size: 10px;">2nd Lane Halwasiya Market</p>
                                                    <p style="text-align: center; margin-bottom: -9px; font-size: 10px;">Hazratganj, Lucknow, UP, INDIA</p>
                                                    <p style="text-align: center; margin-bottom: -9px; font-size: 10px;">GSTIN No.: 09ADNPJ3625L1Z5</p>
                                                    <p style="text-align: center; margin-bottom: 0px; font-size: 10px;">Tel.: +91-9839013698</p>
                                                    <hr />
                                                    <div class="row">
                                                        <div class="col-md-12">
                                                            <span id="printinvSpan"></span><span id="printBillNo"></span>
                                                            <span style="float: right;">Date: <span id="printBillDate"></span></span>
                                                        </div>
                                                    </div>
                                                    <hr style="margin: 0px;" />
                                                    <table class="table table-bordered">
                                                        <thead style="border-bottom: 1px solid black;">
                                                            <tr>
                                                                <th>Sr.</th>
                                                                <th>Description</th>
                                                                <th>Qty</th>
                                                                <th>GST%</th>
                                                                <th>Rate</th>
                                                                <th>D.</th>
                                                                <th style="text-align-last: end !important;">Amount</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody id="printBillItems">
                                                        </tbody>
                                                    </table>
                                                    <hr />
                                                    <div class="tot">
                                                        <div>
                                                            <span id="total1"></span>
                                                        </div>
                                                    </div>
                                                    <hr />
                                                    <div class="in">
                                                        <div>
                                                            <p>(in words) :<span id="inword"></span></p>
                                                        </div>
                                                    </div>
                                                    <hr />
                                                    <div class="total">
                                                        <div>
                                                            <span style="border-bottom: 1px solid #ccc;">GST Summary</span>
                                                        </div>
                                                        <p>CGST: Rs.<span id="printCGST"></span></p>
                                                        <p>SGST: Rs.<span id="printSGST"></span></p>
                                                    </div>
                                                    <hr />
                                                    <div class="gstn12" id="gstn12" style="display: none">
                                                        <div>
                                                            <span style="border-bottom: 1px solid black;">GSTIN BILL - To</span>
                                                        </div>
                                                        <p style="margin: 0px;">Name :<span id="printName"></span></p>
                                                        <p>Address :<span id="printAddress"></span></p>
                                                        <p>GSTIN No :<span id="printGstin"></span></p>
                                                        <hr />
                                                    </div>
                                                    <div>
                                                        <div style="font-size: 10px;">1. Subject to LUCKNOW Jurisdiction only.</div>
                                                        <div style="font-size: 10px;">2. Goods can be exchanged within a week from the bill date.</div>
                                                        <div style="font-size: 10px;">3. Lipstick and Nail Polish cannot be exchanged or returned.</div>
                                                        <h3>Thanks for Visiting us.....</h3>
                                                        <div style="font-size: 10px;">E.& O.E.</div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="row p-3">
                                    <div class="col-md-1"></div>
                                    <div class="col-md-8">
                                        <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control"
                                            Placeholder="Search by Brand / Item Name" OnTextChanged="txtSearch_TextChanged" AutoPostBack="true">
                                        </asp:TextBox>
                                    </div>
                                    <div class="col-md-2">
                                        <asp:Button ID="btnClear" runat="server" Text="Clear"
                                            CssClass="btn btn-secondary" OnClick="btnClear_Click" />
                                    </div>
                                </div>
                                <div style="width: 100%; max-height: 400px; overflow: auto;">
                                    <asp:GridView runat="server" ID="gridview3" AutoGenerateColumns="False"
                                        OnRowDataBound="gridview3_RowDataBound">
                                        <AlternatingRowStyle BackColor="White" />
                                        <Columns>
                                            <asp:TemplateField HeaderText="Bar Code" Visible="false">
                                                <ItemTemplate>
                                                    <asp:Label runat="server" ID="lblssku" Text='<%#Eval("Pid")%>'></asp:Label>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Bar Code">
                                                <ItemTemplate>
                                                    <asp:Label runat="server" ID="lblcode" Text='<%#Eval("Sku")%>'></asp:Label>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Item Description">
                                                <ItemTemplate>
                                                    <asp:Label runat="server" ID="lblname" Text='<%#Eval("Itemdiscription")%>'></asp:Label>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Qty">
                                                <ItemTemplate>
                                                    <asp:Label runat="server" ID="lblqqty" Text='<%#Eval("Qty")%>'></asp:Label>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="GST">
                                                <ItemTemplate>
                                                    <asp:Label runat="server" ID="lblgst" Text='<%#Eval("gstper")%>'></asp:Label>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Dis">
                                                <ItemTemplate>
                                                    <asp:Label runat="server" ID="lblds" Text='<%#Eval("discountper")%>'></asp:Label>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Price">
                                                <ItemTemplate>
                                                    <asp:Label runat="server" ID="lblprice" Text='<%#Eval("Saleprice")%>'></asp:Label>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                        </Columns>
                                        <FooterStyle BackColor="#ca1763" Font-Bold="True" ForeColor="White" />
                                        <HeaderStyle BackColor="#ca1763" Font-Bold="True" ForeColor="White" Height="50px" />
                                        <PagerStyle BackColor="#FFCC66" ForeColor="#333333" HorizontalAlign="Center" />
                                        <RowStyle BackColor="#FFFBD6" ForeColor="#333333" />
                                        <SelectedRowStyle BackColor="#FFCC66" Font-Bold="True" ForeColor="Navy" />
                                        <SortedAscendingCellStyle BackColor="#FDF5AC" />
                                        <SortedAscendingHeaderStyle BackColor="#4D0000" />
                                        <SortedDescendingCellStyle BackColor="#FCF6C0" />
                                        <SortedDescendingHeaderStyle BackColor="#820000" />
                                    </asp:GridView>
                                </div>
                                <div style="text-align: center;" runat="server" visible="false" id="ditext">
                                    <asp:LinkButton ID="lnkPrev" runat="server" OnClick="lnkPrev_Click">Previous</asp:LinkButton>
                                    <asp:Label ID="lblPageInfo" runat="server" Text=""></asp:Label>
                                    <asp:LinkButton ID="lnkNext" runat="server" OnClick="lnkNext_Click">Next</asp:LinkButton>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script type="text/javascript">
        window.onload = function () {
            document.getElementById('<%= txtitemcode.ClientID %>').focus();
        };
    </script>
    <script type="text/javascript">
        var isDataSaved = false;
        function saveData() {
            debugger;
            var lcgst = document.getElementById('<%= lblcgst.ClientID %>').innerText;
            var lsgst = document.getElementById('<%= lblsgst.ClientID %>').innerText;
            var llabel25 = document.getElementById('<%= Label25.ClientID %>').value;
            var billno1 = document.getElementById('<%= lblbillno1.ClientID %>').innerText;
            var billnoc1 = document.getElementById('<%= lblbillno1c.ClientID %>').innerText;
            var lbltend = document.getElementById('<%= txttend.ClientID %>').value;
            var lblcard = document.getElementById('<%= txtcardno.ClientID %>').value;
            var type = document.getElementById('<%= txttype.ClientID %>').value;
            var no1 = document.getElementById('<%= txtno1.ClientID %>').value;
            var no2 = document.getElementById('<%= txtno2.ClientID %>').value;
            var upi = document.getElementById('<%= txtupi.ClientID %>').value;
            var dis = document.getElementById('<%= txtdis.ClientID %>').value;
            var diss = document.getElementById('<%= txtadddis.ClientID %>').value;
            var subtotl = document.getElementById('<%= subtotal.ClientID %>').value;

            var radioValue = document.querySelector('input[name="<%= rblOptions.UniqueID %>"]:checked');
            if (radioValue === null) {
                alert("Please select a payment method.");
                return;
            }
            radioValue = radioValue.value;
            var autid = document.getElementById('<%= autid.ClientID %>').value;
            var mob = document.getElementById('<%= txtmobile.ClientID %>').value;
            var txtname = document.getElementById('<%= txtname.ClientID %>').value;
            var txtgstn = document.getElementById('<%= txtgstn.ClientID %>').value;
            var txtadd = document.getElementById('<%= txtadd.ClientID %>').value;
            var partyna = document.getElementById('<%= txtparty.ClientID %>').value;
            var txtmobileno = document.getElementById('<%= txtmno.ClientID %>').value;
            var emailadd = document.getElementById('<%= txtemail.ClientID %>').value;
            var dob = document.getElementById('<%= txtdob.ClientID %>').value;
            var wedding = document.getElementById('<%= txtannievr.ClientID %>').value;
            var xhr = new XMLHttpRequest();
            xhr.open("POST", "Bill.aspx/InsertData", true);
            xhr.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
            var data = JSON.stringify({
                lcgst: lcgst,
                lsgst: lsgst,
                llabel25: llabel25,
                billno1: billno1,
                lbltend: lbltend,
                lblcard: lblcard,
                type: type,
                no1: no1,
                no2: no2,
                upi: upi,
                billnoc1: billnoc1,
                radioValue: radioValue,
                autid: autid,
                txtname: txtname,
                txtgstn: txtgstn,
                dis: dis,
                mob: mob,
                diss: diss,
                partyna: partyna,
                txtmobileno: txtmobileno,
                emailadd: emailadd,
                dob: dob,
                wedding: wedding,
                subtotl: subtotl,
                txtadd: txtadd
            });

            xhr.onload = function () {
                if (xhr.status === 200) {
                    var response = xhr.responseText;
                    try {
                        var result = JSON.parse(response);
                        response = result.d;
                    } catch (e) {
                        Swal.fire("Error", "Invalid server response: " + response, "error");
                        return;
                    }
                    if (response.startsWith("Error:") || response.startsWith("Database error:") || response.includes("Session expired")) {
                        Swal.fire("Error", response, "error");
                        isDataSaved = false;
                        document.getElementById("btnprint").style.display = "none";
                        document.getElementById("btnsubmit2").style.display = "inline-block";
                    } else {
                        isDataSaved = true;
                        document.getElementById("btnprint").style.display = "inline-block";
                        document.getElementById("btnsubmit2").style.display = "none";

                        Swal.fire({
                            title: "Success",
                            text: response,
                            icon: "success",
                            confirmButtonText: "OK"
                        }).then((result) => {
                            if (result.isConfirmed) {
                                document.getElementById("btnprint").click();
                            }
                        });
                    }
                } else {
                    Swal.fire("Error", "Request failed: " + xhr.statusText, "error");
                    document.getElementById("btnprint").style.display = "none";
                    document.getElementById("btnsubmit2").style.display = "inline-block";
                }
            };


            xhr.send(data);
        }
        function numberToWords(num) {
            debugger;
            var a = [
                '', 'One', 'Two', 'Three', 'Four', 'Five', 'Six', 'Seven', 'Eight', 'Nine',
                'Ten', 'Eleven', 'Twelve', 'Thirteen', 'Fourteen', 'Fifteen', 'Sixteen', 'Seventeen', 'Eighteen', 'Nineteen'
            ];
            var b = [
                '', '', 'Twenty', 'Thirty', 'Forty', 'Fifty', 'Sixty', 'Seventy', 'Eighty', 'Ninety'
            ];
            var g = ['', 'Thousand', 'Million', 'Billion', 'Trillion'];
            var s = '';

            if (num === 0) return 'Zero';
            var i = 0;
            while (num > 0) {
                if (num % 1000 !== 0) {
                    s = numberHelper(num % 1000) + g[i] + ' ' + s;
                }
                num = Math.floor(num / 1000);
                i++;
            }
            return s.trim();
            function numberHelper(n) {
                if (n === 0) return '';
                if (n < 20) return a[n] + ' ';
                else if (n < 100) return b[Math.floor(n / 10)] + ' ' + a[n % 10] + ' ';
                else {
                    return a[Math.floor(n / 100)] + ' Hundred ' + numberHelper(n % 100);
                }
            }
        }
    </script>
    <script type="text/javascript">
        function printDiv() {
            debugger;
            if (!isDataSaved) {
                alert("Please save the data before printing.");
                return;
            }
            function parseNumber(text) {
                if (text === null || text === undefined) return 0;
                var cleaned = String(text).replace(/,/g, '').replace(/[^\d\.\-]/g, '').trim();
                var n = parseFloat(cleaned);
                return isNaN(n) ? 0 : n;
            }

            var billNo = document.getElementById('<%= lblbillno1.ClientID %>').innerText;
            var billNoc = document.getElementById('<%= lblbillno1c.ClientID %>').innerText;
            var billDate = document.getElementById('<%= txtbilldate.ClientID %>').innerText;
            var totalAmount = document.getElementById('<%= lbltotal.ClientID %>').innerText;
            var cgstAmount = document.getElementById('<%= lblcgst.ClientID %>').innerText;
            var sgstAmount = document.getElementById('<%= lblsgst.ClientID %>').innerText;
            var pName = document.getElementById('<%= txtname.ClientID %>').value;
            var pgstin = document.getElementById('<%= txtgstn.ClientID %>').value;
            var pAdd = document.getElementById('<%= txtadd.ClientID %>').value;
            var total = document.getElementById('<%= Label25.ClientID %>').value;
            var totaldisText = document.getElementById('<%= lbldis.ClientID %>').innerText;

            var totalAmount = parseNumber(totalAmount);
            var totaldis = parseNumber(totaldisText);
            document.getElementById('printBillNo').innerText = billNo;
            document.getElementById('printBillDate').innerText = billDate;
            document.getElementById('printCGST').innerText = cgstAmount;
            document.getElementById('printSGST').innerText = sgstAmount;
            document.getElementById('printName').innerText = pName;
            document.getElementById('printAddress').innerText = pAdd;
            document.getElementById('printGstin').innerText = pgstin;
            var isGSTINSelected = $("input[name='<%= rblOptions.UniqueID %>']:checked").val() === '5';
            var isGSTINSelected1 = $("input[name='<%= rblOptions.UniqueID %>']:checked").val() === '4';
            var gstn12Div = document.getElementById('gstn12');
            if (isGSTINSelected) {
                gstn12Div.style.display = 'block';
            } else {
                gstn12Div.style.display = 'none';
            }

            if (isGSTINSelected1) {
                document.getElementById('printBillNo').innerText = billNoc;
            }
            var printTitle1 = isGSTINSelected1 ? "CN No.:" : "Inv. No:";
            document.getElementById('printinvSpan').innerText = printTitle1;
            var printTitle = isGSTINSelected1 ? "Credit Note" : "TAX INVOICE";
            document.getElementById('printTitleSpan').innerText = printTitle;
            var gridRows = document.getElementById('<%= gridview1.ClientID %>').getElementsByTagName('tbody')[0].getElementsByTagName('tr');
            var printBillItems = document.getElementById('printBillItems');
            printBillItems.innerHTML = '';
            var grandTotal = 0;
            var totalQty = 0;
            var grossTotal = 0;
            var totalDiscount = 0;
            var totalReturnQty = 0;
            for (var i = 1; i < gridRows.length; i++) {
                var row = gridRows[i];
                var cells = row.getElementsByTagName('td');
                if (cells.length > 0) {
                    var itemDesc = cells[2].innerText;
                    var gst = parseNumber(cells[3].innerText);
                    var disper = parseNumber(cells[4].innerText);
                    var disamt1 = parseNumber(cells[5].innerText);
                    var qty = cells[6].innerText;
                    var rate = parseNumber(cells[7].innerText);
                    var amt = parseNumber(cells[8].innerText);
                    var totlamt = rate * qty;
                    var totalGST = parseFloat(gst);
                    var cgstPercent = totalGST / 2;
                    var disamt = (totlamt * disper) / 100;
                    var gstAmount = (parseFloat(totlamt) * totalGST) / (100 + totalGST);
                    var cgstAmount = gstAmount / 2;
                    var sgstAmount = cgstAmount;
                    var amtWithoutGST = totlamt - gstAmount;
                    if (qty < 0) {
                        totalReturnQty += Math.abs(parseFloat(qty) || 0);
                    } else {
                        totalQty += parseFloat(qty) || 0;
                    }
                    grossTotal += totlamt;

                    var rowDiscount = 0;
                    var discountDisplay = '0';

                    if (!isNaN(disper) && disper > 0) {
                        rowDiscount = (totlamt * disper) / 100;
                        discountDisplay = disper + '%';
                    } else if (!isNaN(disamt1) && disamt1 > 0) {
                        rowDiscount = disamt1;
                        discountDisplay = disamt1.toFixed(2);
                    }
                    totalDiscount += rowDiscount;
                    if (!isNaN(rate) && !isNaN(amt)) {
                        var rowHTML =
                            '<tr>' +
                            '<td>' + i + '</td>' +
                            '<td colspan="6" style="font-size: 10px;">' + itemDesc + '</td>' +
                            '</tr>' +
                            '<tr>' +
                            '<td></td>' +
                            '<td></td>' +
                            '<td>' + qty + '</td>' +
                            '<td>' + gst + '</td>' +
                            '<td>' + rate.toFixed(2) + '</td>' +
                            '<td>' + discountDisplay + '</td>' +
                            '<td style="text-align:right;">' + amt.toFixed(2) + '</td>' +
                            '</tr>';
                        printBillItems.innerHTML += rowHTML;
                        grandTotal += amt;

                    }

                }
            }
            var roundedTotal = Math.round(grandTotal);
            var roundOff = (roundedTotal - grandTotal).toFixed(2);
            var roundOffDisplay = '';

            if (parseFloat(roundOff) !== 0) {
                var displayRound = roundOff < 0 ? roundOff : Math.abs(roundOff).toFixed(2);
                roundOffDisplay =
                    '<tr>' +
                    '<td colspan="6" style="text-align:left;">Round Off</td>' +
                    '<td style="text-align:right;">' + displayRound + '</td>' +
                    '</tr>';
            }
            var totalHTML =
                '<tr>' +
                '<td colspan="3" style="text-align:left; width: 30% !important;">Total item = ' + Math.round(totalQty) + '</td>';
            if (totaldis > 0) {
                totalHTML += '<td colspan="4" style="text-align:left;">You save on this bill Rs. = ' + totaldis.toFixed(2) + '</td>';
            } else {
                totalHTML += '<td colspan="4"></td>';
            }
            totalHTML += '</tr>';
            if (totalReturnQty > 0) {
                totalHTML += '<tr><td colspan="7" style="text-align:left;">Total return item = ' + Math.round(totalReturnQty) + '</td></tr>';
            }
            totalHTML +=
                '<tr>' +
                '<td colspan="6">Total (Rate × Qty)</td>' +
                '<td style="text-align:right;">' + total.toFixed(2) + '</td>' +
                '</tr>' +

                '<tr>' +
                '<td colspan="6">Total Discount</td>' +
                '<td style="text-align:right;">' + totaldis.toFixed(2) + '</td>' +
                '</tr>' +
                '<tr>' +
                '<td colspan="6" style="text-align:left;">Total</td>' +
                '<td style="text-align:right;">' + grandTotal.toFixed(2) + '</td>' +
                '</tr>' +

                roundOffDisplay +
                '<tr>' +
                '<td colspan="6" style="text-align:left; font-weight:bold;">Net Total</td>' +
                '<td style="text-align:right; font-weight:bold;">' + roundedTotal.toFixed(2) + '</td>' +
                '</tr>';
            document.getElementById('total1').innerHTML = '<table style="width:100%; font-size:12px;">' + totalHTML + '</table>';
            if (roundedTotal < 0) {
                grandTotalInWords = '' + numberToWords(Math.abs(roundedTotal)).toUpperCase();
            } else {
                grandTotalInWords = numberToWords(roundedTotal).toUpperCase();
            }
            document.getElementById('inword').innerText = grandTotalInWords + ' ONLY';
            var printArea = document.getElementById('printArea');
            printArea.style.display = 'block';
            var printWindow = window.open('', '', 'height=800, width=600');
            printWindow.document.write('<html><head><title></title>');
            printWindow.document.write('<style>' +
                'body { font-family: Arial, sans-serif; font-weight: 600; margin: 0; padding: 0; font-size: 12px; }' +
                '@page { size: A4; margin: 10mm; }' +
                'body { margin: 0; padding: 0; width: 100%; height: 100%; text-align: left; }' +
                '.content {width: 3in; margin-left: 0; padding: 0; }' +
                'table {width: 100%; border-collapse: collapse; }' +
                'th, td {padding: 1px; text-align: left; font-size: 11px; }' +
                'th {background - color: #f2f2f2; }' +
                'td:nth-child(1) { width: 8% !important; text-align:left;}' +
                'td:nth-child(2) { width: 52% !important; font-size: 11px; }' +
                'td:nth-child(3) { width: 10% !important; }' +
                'td:nth-child(4) { width: 10%; }' +
                'td:nth-child(5) { width: 7%; text-align:center;}' +
                'td:nth-child(6) { width: 15%;}' +
                'hr { border-top: 1px solid black;margin-top: 5px;margin-bottom: 2px; }' +
                '.tot p {margin: 0; padding-top: 5px; }' +
                '#inword { font-size: 9px; font-weight: 600; margin-top: 5px; }' +
                '.in p {font - size: 12px; margin: 0; padding-top: 5px; }' +
                '.total p {font - size: 12px; margin: 0; padding-top: 5px; }' +
                '.gstn12 p {font - size: 12px; margin: 0; padding-top: 5px; }' +
                '</style>');
            printWindow.document.write('</head><body>');
            printWindow.document.write('<div class="content">' + printArea.innerHTML + '</div>');
            printWindow.document.write('</body></html>');
            printWindow.document.close();
            printWindow.print();
            setTimeout(function () {
                printArea.style.display = 'none';
            }, 3000);
            window.location = "Bill.aspx";
        }
    </script>
    <script>
        $(document).ready(function () {
            function toggleSections() {
                var selectedValue = $("input[name='<%= rblOptions.UniqueID %>']:checked").val();

                $("#cardRow, #typeRow12, #cradit, #tyt, #ingst").hide();

                if (selectedValue == "2") {
                    $("#cardRow").show();
                }
                else if (selectedValue == "3") {
                    $("#typeRow12").show();
                }
                else if (selectedValue == "4") {
                    $("#cradit").show();
                }
                else if (selectedValue == "5") {
                    $("#ingst").show();
                }
                else if (selectedValue == "6") {
                    $("#tyt").show();
                }
            }
            toggleSections();
            $("input[name='<%= rblOptions.UniqueID %>']").change(function () {
                toggleSections();
            });
            function checkMobileNumber() {
                var mobileNumber = $('#<%= txtgstn.ClientID %>').val().trim();
            var gstinRadioButton = $("input[name='<%= rblOptions.UniqueID %>'][value='5']");

                if (mobileNumber.length > 0) {
                    gstinRadioButton.prop('checked', true);
                }
                toggleSections();
            }
            checkMobileNumber();
            $('#<%= txtgstn.ClientID %>').on('input', function () {
                checkMobileNumber();
            });
        });
    </script>
    <script type="text/javascript">
        document.getElementById("myCheckbox1").onclick = function () {
            if (this.checked) {
                window.location.href = "Suppliermaster.aspx";
            }
        };
        document.getElementById("myCheckbox2").addEventListener("click", function () {
            debugger;
            var grid = document.getElementById("<%= gridview1.ClientID %>");
            var rowCount = grid ? grid.rows.length - 1 : 0;

            if (rowCount > 0) {
                var myModal = new bootstrap.Modal(document.getElementById('popupModal1'));
                myModal.show();
            } else {
                Swal.fire({
                    icon: 'warning',
                    title: 'Oops...',
                    text: 'Please add at least one item before opening modal!',
                }).then(() => {
                    this.checked = false;
                });
            }
        });
    </script>
    <script>
        function onqtychange(isPercentChange) {

            let qty = parseFloat(document.getElementById("<%=txtqty.ClientID%>").value) || 0;
            let rt = parseFloat(document.getElementById("<%=txtrate.ClientID%>").value) || 0;
            let gst = parseFloat(document.getElementById("<%=txtgst.ClientID%>").value) || 0;

            let disPercentCtrl = document.getElementById("<%=txtdisss.ClientID%>");
            let disAmtCtrl = document.getElementById("<%=txtdiscout.ClientID%>");

            let disPercent = parseFloat(disPercentCtrl.value) || 0;
            let disAmtInput = parseFloat(disAmtCtrl.value) || 0;

            let baseAmt = qty * rt;
            let disAmt = 0;
            if (isPercentChange) {
                disAmtCtrl.value = "";
                disAmtInput = 0;
            }
            else if (disAmtInput > 0) {
                disPercentCtrl.value = "0";
                disPercent = 0;
            }

            if (disAmtInput > 0) {
                disAmt = Math.abs(disAmtInput);
            }
            else if (disPercent > 0) {
                disAmt = Math.abs((baseAmt * disPercent) / 100);
                disAmtCtrl.value = disAmt.toFixed(2);
            }
            let finalAmt = baseAmt - disAmt;
            document.getElementById("<%=txtamt.ClientID%>").value = finalAmt.toFixed(2);
        }
        function ratechange() {
            onqtychange();
        }
        function ondischange() {
            debugger;
            let txvalue = parseFloat(document.getElementById("<%=subtotal.ClientID%>").value.trim());
            let cst1 = parseFloat(document.getElementById("<%=lblCGst1.ClientID%>").value.trim());
            let sgst = parseFloat(document.getElementById("<%=Label23.ClientID%>").value.trim());
            let diss = parseFloat(document.getElementById("<%=txtdis.ClientID%>").value.trim());
            let adddis = parseFloat(document.getElementById("<%=txtadddis.ClientID%>").value.trim());
            let totl = (txvalue + cst1 + sgst) - (diss + adddis);
            let sum = totl;
            document.getElementById("<%=Label25.ClientID%>").value = sum.toFixed(2);

        }
        function ontendchan() {
            let ftol = parseFloat(document.getElementById("<%=Label25.ClientID%>").value.trim());
            let bla = parseFloat(document.getElementById("<%=TextBox10.ClientID%>").value.trim());
            let bale = bla - ftol;;
            document.getElementById("<%=txttend.ClientID%>").value = bale.toFixed(2);
        }
    </script>
    <script>
        function print() {

        }
    </script>
    <script type="text/javascript">
        function fillData(code, item, qty, rate, gst, aQty, dis, cloth) {
            document.getElementById('<%= txtitemcode.ClientID %>').value = code;
            document.getElementById('<%= txtrate.ClientID %>').value = rate;
            document.getElementById('<%= txtgst.ClientID %>').value = gst;
            document.getElementById('<%= txtitem.ClientID %>').value = item;
            document.getElementById('<%= txtdisss.ClientID %>').value = dis;
            document.getElementById('<%= lblqty1.ClientID %>').innerText = "Avail Qty = " + aQty;
            document.getElementById('<%= txtqty.ClientID %>').value = 1;
            document.getElementById('<%= txtcloth.ClientID %>').value = cloth;
            onqtychange();
        }
        function updateGST() {
            let cloth = parseInt(document.getElementById('<%= txtcloth.ClientID %>').value) || 0;
            let rate = parseFloat(document.getElementById('<%= txtrate.ClientID %>').value.trim()) || 0;

            if (cloth === 1) {
                if (rate < 2500) {
                    document.getElementById('<%= txtgst.ClientID %>').value = 5;
            } else {
                document.getElementById('<%= txtgst.ClientID %>').value = 18;
                }
            }
        }
        document.getElementById("<%=txtdisss.ClientID%>").addEventListener("input", function () {
            onqtychange(true);
        });
        document.getElementById("<%=txtdiscout.ClientID%>").addEventListener("input", function () {
            onqtychange();
        });
        document.getElementById("<%=txtqty.ClientID%>").addEventListener("input", function () {
            onqtychange();
        });
      <%--  document.addEventListener("DOMContentLoaded", function () {
            document.getElementById("<%=txtdisss.ClientID%>").addEventListener("input", onqtychange);
            document.getElementById("<%=txtrate.ClientID%>").addEventListener("input", onqtychange);
            document.getElementById("<%=txtqty.ClientID%>").addEventListener("input", onqtychange);
        });--%>
    </script>


</asp:Content>

