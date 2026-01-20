<%@ Page Title="" Language="C#" MasterPageFile="~/BillingMaster.master" AutoEventWireup="true" CodeFile="Restaurant_Settlement.aspx.cs" Inherits="Restaurant_Settlement" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style>
        th {
            background: #1b4071;
            height: 50px;
        }

        .radio-gap input[type=radio] {
            margin-right: 6px;
        }

        .radio-gap label {
            margin-right: 30px;
        }

        .section-title1 {
            border-bottom: 1px solid #e5e5e5;
            padding: 6px;
            text-align: center;
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
    <div class="container">
        <div class="row">
            <div class="col-md-12">
                <div class="row">
                    <div class="col-md-2"></div>
                    <div class="col-md-8" style="border: 1px solid #ccc;">
                        <div class="row">
                            <div class="section-title1">
                                <h2>Bill Settelment</h2>
                            </div>
                            <div class="col-md-12">
                                <asp:Panel runat="server" ID="panel1" Visible="false" Style="border-radius: 7px; overflow-y: scroll; overflow-y: scroll; height: 522px; margin-top:10px;">
                                    <asp:GridView ID="gridview1" runat="server" BorderWidth="1" AutoGenerateColumns="false" CellPadding="4" GridLines="None" Font-Size="15px" DataKeyNames="bill_no,table_no,grandtotal" Width="100%">
                                        <Columns>
                                            <asp:TemplateField HeaderText="Sr.No.">
                                                <ItemTemplate><%#Container.DataItemIndex+1 %></ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Bill No.">
                                                <ItemTemplate>
                                                    <asp:Label runat="server" ID="lblbill" Text='<%#Eval("bill_no")%>'></asp:Label>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Table No.">
                                                <ItemTemplate>
                                                    <asp:Label runat="server" ID="lbltable" Text='<%#Eval("table_no")%>'></asp:Label>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Date">
                                                <ItemTemplate>
                                                    <asp:Label runat="server" ID="lbldate" Text='<%#Eval("bill_date")%>'></asp:Label>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Amount">
                                                <ItemTemplate>
                                                    <asp:Label runat="server" ID="lblamt" Text='<%#Eval("grandtotal")%>'></asp:Label>
                                                </ItemTemplate>
                                                <ItemStyle HorizontalAlign="Right" />
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Settle">
                                                <ItemTemplate>
                                                    <asp:LinkButton runat="server" ID="btnsettel" Height="30px" Style="padding-top: 3px;" Text="Settle" Class="btn btn-info" OnClick="btnsettel_Click"></asp:LinkButton>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                        </Columns>
                                        <FooterStyle BackColor="#F7DFB5" ForeColor="#8C4510" />
                                        <HeaderStyle BackColor="#f9580e" Font-Bold="True" ForeColor="White" HorizontalAlign="Center" />
                                        <PagerStyle ForeColor="#8C4510" HorizontalAlign="Center" />
                                        <RowStyle BackColor="#F8FAF9" ForeColor="#060606" HorizontalAlign="Center" />
                                        <SelectedRowStyle BackColor="#738A9C" Font-Bold="True" ForeColor="White" />
                                        <SortedAscendingCellStyle BackColor="#FFF1D4" />
                                        <SortedAscendingHeaderStyle BackColor="#B95C30" />
                                        <SortedDescendingCellStyle BackColor="#F1E5CE" />
                                        <SortedDescendingHeaderStyle BackColor="#93451F" />
                                    </asp:GridView>
                                </asp:Panel>
                                <asp:Panel runat="server" ID="panel2" Visible="true" Style="border-radius: 7px; overflow-y: scroll; overflow-y: scroll; height: 522px; margin-top:10px;">
                                    <div class="row">
                                        <div class="col-md-1"></div>
                                        <div class="col-md-10" style="border-radius: 7px; padding-top: 15px;">
                                            <div class="form-group">
                                                <div class="row">
                                                    <div class="col-md-4">
                                                        <asp:Label runat="server" ID="lbb" Text="Bill No. :" ForeColor="Black"></asp:Label>
                                                        <asp:Label runat="server" ID="lblbillno" Text="" ForeColor="Black"></asp:Label>
                                                    </div>
                                                    <div class="col-md-3">
                                                        <asp:Label runat="server" ID="Label1" Text="Table No. :" ForeColor="Black"></asp:Label>
                                                        <asp:Label runat="server" ID="lbltableno" Text="" ForeColor="Black"></asp:Label>
                                                    </div>
                                                    <div class="col-md-5">
                                                        <asp:Label runat="server" ID="Label3" Text="Total Amount :" ForeColor="Black"></asp:Label>
                                                        <asp:Label runat="server" ID="lbltamt" Text="0.00" ForeColor="Black"></asp:Label>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="form-group mt-3">
                                                <div class="row">
                                                    <div class="col-md-4">
                                                        <h6>Payment Mode :</h6>
                                                    </div>
                                                    <div class="col-md-6">
                                                        <div class="form-group">
                                                            <div class="row">
                                                                <div class="col-md-12">
                                                                    <asp:RadioButtonList runat="server" ID="rbtnpaymode" ForeColor="Black" RepeatDirection="Horizontal" CssClass="radio-gap">
                                                                        <asp:ListItem Text="Cash Sale" Value="0"></asp:ListItem>
                                                                        <asp:ListItem Text="Credit Card Sale" Value="1" CssClass="chk-gap"></asp:ListItem>
                                                                    </asp:RadioButtonList>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-2"></div>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <div class="row mt-3">
                                                    <div class="col-md-4"></div>
                                                    <div class="col-md-8">
                                                        <asp:Button runat="server" ID="btnsettle" Text="Settle Bill" class="btn btn-info" Font-Bold="true" OnClick="btnsettle_Click" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                    <asp:Button runat="server" ID="btnback" Text="Back" class="btn btn-danger" Width="85px" Font-Bold="true" OnClick="btnback_Click" />
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-1"></div>
                                    </div>
                                </asp:Panel>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-2"></div>
            </div>
        </div>
    </div>
</asp:Content>

