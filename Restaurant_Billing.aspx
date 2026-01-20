<%@ Page Title="" Language="C#" MasterPageFile="~/BillingMaster.master" AutoEventWireup="true" CodeFile="Restaurant_Billing.aspx.cs" Inherits="Restaurant_Billing" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style>
        .form-control {
            height: 31px;
        }

        .l {
            text-align: right !important;
        }

        .grid-header-border {
            border-top: 1px solid black !important;
            border-bottom: 1px solid black !important;
        }

        @media print {
            body * {
                visibility: hidden;
            }

            #print, #print * {
                visibility: visible;
            }

            #print {
                position: absolute;
                left: 0;
                top: 0;
                width: 100%;
            }
        }

        .section-title1 {
            border-bottom: 1px solid #ccc;
            padding: 12px;
            text-align: center;
        }

        @media print {

            @page {
                size: A4;               
            }               

            #print {
            
                width: 3.3in; 
                font-size: 12px;
                font-family: Arial, sans-serif;

            }
            td{
                font-size:12px;
            }
          
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="container">
        <div class="form-group">
            <div class="row">
                <div class="col-md-3"></div>
                <div class="col-md-6" style="box-shadow: 0px 1px 4px 1px #ccc; border-radius: 5px; background-color: white;">
                    <div class="form-group">
                        <div class="section-title1">
                            <h2 style="margin-bottom: 0px;">Print Bill</h2>
                        </div>
                        <div class="row" style="padding-top: 25px;">
                            <div class="col-md-2">
                                <asp:Label runat="server" ID="lbl1" Text="Bill Date : " ForeColor="Black"></asp:Label>
                            </div>
                            <div class="col-md-2">
                                <asp:Label runat="server" ID="lbldate" Text="" ForeColor="red" Font-Size="15px"></asp:Label>
                            </div>
                            <div class="col-md-2">
                                <asp:Label runat="server" ID="Label1" Text="Bill No. : " ForeColor="Black"></asp:Label>
                            </div>
                            <div class="col-md-2">
                                <asp:Label runat="server" ID="lblbillno" Text="" ForeColor="red" Font-Size="15px"></asp:Label>
                                <asp:Label runat="server" ID="lblkotno" Visible="false" Text="" ForeColor="red" Font-Size="15px"></asp:Label>
                            </div>
                            <div class="col-md-2">
                                <asp:Label runat="server" ID="Label3" Text="Table No. : " ForeColor="Black"></asp:Label>

                            </div>
                            <div class="col-md-2">
                                <asp:Label runat="server" ID="lbltable" Text="01" ForeColor="red" Font-Size="15px"></asp:Label>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="row" style="padding-top: 15px;">
                            <div class="col-md-2">
                                <asp:Label runat="server" ID="Label5" Text="Sub Total :" ForeColor="Black"></asp:Label>
                            </div>
                            <div class="col-md-2">
                                <asp:Label runat="server" ID="lblsuttotal" Text="0.00" ForeColor="red" Font-Size="15px"></asp:Label>
                            </div>
                            <div class="col-md-2">
                                <asp:Label runat="server" ID="Label2" Text="Discount%: " ForeColor="Black"></asp:Label>
                            </div>
                            <div class="col-md-2">
                                <asp:Label runat="server" ID="lbldisamount" Text="0.00" ForeColor="red" Font-Size="15px"></asp:Label>
                            </div>
                            <div class="col-md-2">
                                <asp:Label runat="server" ID="Label7" Text="Total :" ForeColor="Black"></asp:Label>

                            </div>
                            <div class="col-md-2">
                                <asp:Label runat="server" ID="lbltotal" Text="0.00" ForeColor="red" Font-Size="15px"></asp:Label>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="row" style="padding-top: 15px;">
                            <div class="col-md-2">
                                <asp:Label runat="server" ID="Label11" Text="GST%:" ForeColor="Black"></asp:Label>
                            </div>
                            <div class="col-md-2">
                                <asp:Label runat="server" ID="txtgst" ReadOnly="true" ForeColor="red" Font-Size="15px"></asp:Label>
                                <asp:Label runat="server" ID="lblgstamt" Visible="false"></asp:Label>
                            </div>
                            <div class="col-md-2 p-0">
                                <asp:Label runat="server" ID="Label13" Text="Grand Total:" Font-Bold="true" ForeColor="Black"></asp:Label>

                            </div>
                            <div class="col-md-2">
                                <asp:Label runat="server" ID="lblgtotal" Text="0.00" ForeColor="Black" Font-Bold="true"></asp:Label>

                            </div>
                            <div class="col-md-4"></div>
                        </div>
                    </div>
                    <div class="form-group mt-2">
                        <div class="row" style="border-top: 1px solid #ccc; padding: 5px;">
                            <div class="col-md-4"></div>
                            <div class="col-md-8 p-2">
                                <asp:Button
                                    ID="btnPrint"
                                    runat="server"
                                    Text="Print Bill"
                                    CssClass="btn btn-info"
                                    OnClick="btnPrint_Click" />
                                &nbsp;&nbsp;
                                  <asp:Button runat="server" ID="btncancel" Text="Cancel" Class="btn btn-danger" Font-Bold="true" Width="90px" OnClick="btncancel_Click" />
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3"></div>
            </div>
        </div>
        <div class="row" runat="server" id="bill" style="margin-top: 10px" visible="false">
            <div class="col-md-3"></div>
            <div class="col-sm-6" id="print">
                <div class="row">
                    <div class="col-md-12">
                        <div class="row">
                            <div class="col-md-12">
                                <h4 style="text-align: center;font-size: 14px; font-weight: 550; margin-bottom:2px;">Bill Invoice</h4>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12">
                                <h4 style="text-align: center; font-family: cursive; font-size: 22px; color: black;font-weight: 900;margin-bottom:3px;">Charans Club & Resorts</h4>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12">
                                <h4 style="text-align: center;font-size: 12px; color: black; margin-bottom:2px;">Reliance Petrol Pump,Matiyari,Chinhat, Lucknow,Uttar Pradesh</h4>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12">
                                <h4 style="text-align: center; font-size: 12px; color: black; margin-bottom: 2px;">Phone : 0123456789</h4>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12">
                                <h4 style="text-align: center; font-size: 12px; color: black; font-weight: 500;margin-bottom:3px;">GST No. : 09AAAAG56DS14SG</h4>
                            </div>
                        </div>
                        <div class="form-group" style="border-top: 1px solid black; padding-top: 1px; margin-bottom: 1px !important;">
                            <table style="width: 100%; font-size: 13px;">
                                <tr>
                                    <td style="width: 50%;">
                                        <asp:Label runat="server" ID="lbl" Text="Bill No.:" ForeColor="Black"></asp:Label>
                                        <asp:Label runat="server" ID="Label6" Text="" ForeColor="Black"></asp:Label>
                                    </td>
                                   <%-- <td style="width: 33%; text-align: center;">
                                        <asp:Label runat="server" ID="Label9" Text="Table No.:" ForeColor="Black"></asp:Label>
                                        <asp:Label runat="server" ID="Label10" Text="" ForeColor="Black"></asp:Label>
                                    </td>--%>
                                    <td style="width: 50%; text-align: right;">
                                        <asp:Label runat="server" ID="Label8" Text="Bill Date:" ForeColor="Black"></asp:Label>
                                        <asp:Label runat="server" ID="lblbilldate" Text="06/09/2022" ForeColor="Black"></asp:Label>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div class="form-group">
                            <div class="row">
                                <div class="col-md-12">
                                    <asp:Panel runat="server" ID="panel1">
                                        <asp:GridView runat="server" ID="gridbill"
                                            AutoGenerateColumns="False" Width="100%"
                                            BackColor="White"
                                            BorderColor="Transparent"
                                            BorderStyle="None"
                                            BorderWidth="0px"
                                            CellPadding="2"
                                            GridLines="None">
                                            <Columns>
                                                <asp:TemplateField HeaderText="Sr." HeaderStyle-Width="6%">
                                                    <ItemTemplate><%#Container.DataItemIndex+1 %></ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Item Name" HeaderStyle-Width="54%">
                                                    <ItemTemplate>
                                                        <asp:Label runat="server" ID="lblitem" Text='<%#Eval("itemname")%>'></asp:Label>
                                                    </ItemTemplate>
                                                    <ItemStyle HorizontalAlign="Left" />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Qty" HeaderStyle-Width="6%">
                                                    <ItemTemplate>
                                                        <asp:Label runat="server"
                                                            ID="lblitem"
                                                            Text='<%# Eval("qty", "{0:0}") %>'>
                                                        </asp:Label>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Rate" HeaderStyle-Width="17%" HeaderStyle-CssClass="l">
                                                    <ItemTemplate>
                                                        <asp:Label runat="server" ID="lblitem" Text='<%#Eval("rate")%>'></asp:Label>
                                                    </ItemTemplate>
                                                    <ItemStyle HorizontalAlign="right" />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Amount" HeaderStyle-Width="17%" HeaderStyle-CssClass="l">
                                                    <ItemTemplate>
                                                        <asp:Label runat="server" ID="lblitem" Text='<%#Eval("amount")%>'></asp:Label>
                                                    </ItemTemplate>
                                                    <ItemStyle HorizontalAlign="right" />
                                                </asp:TemplateField>
                                            </Columns>
                                            <HeaderStyle CssClass="grid-header-border" BackColor="#e5ded8" Font-Bold="True" ForeColor="Black" />
                                            <RowStyle BackColor="White" ForeColor="Black" Font-Size="14px" />
                                        </asp:GridView>
                                    </asp:Panel>
                                </div>
                            </div>
                            <table style="width: 100%; font-size: 15px; border-collapse: collapse; margin-top: 3px;">
                                <tr>
                                    <td colspan="2" style="border-top: 1px solid black;"></td>
                                </tr>
                                <tr>
                                    <td style="text-align: left;">
                                        <asp:Label runat="server" ID="Label12" Text="Total :"
                                            ForeColor="Black" Style="font-weight: 600; font-size: 15px;"></asp:Label>
                                    </td>
                                    <td style="text-align: right;">
                                        <asp:Label runat="server" ID="lblptotal" Text="0.00"
                                            ForeColor="Black" Style="font-weight: 600; font-size: 15px;"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td id="discountRow" style="text-align: left;">
                                        <asp:Label runat="server" ID="Label14" Text="Discount :"
                                            ForeColor="Black" Style="font-weight: 600; font-size: 15px;"></asp:Label>
                                    </td>
                                    <td style="text-align: right;">
                                        <asp:Label runat="server" ID="lbldiscount" Text="0.00"
                                            ForeColor="Black" Style="font-weight: 600; font-size: 15px;"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: left;">
                                        <asp:Label runat="server" ID="Label16" Text="GST 5% :"
                                            ForeColor="Black" Style="font-weight: 600; font-size: 15px;"></asp:Label>
                                    </td>
                                    <td style="text-align: right;">
                                        <asp:Label runat="server" ID="Label17" Text="0.00"
                                            ForeColor="Black" Style="font-weight: 600; font-size: 15px;"></asp:Label>
                                    </td>
                                </tr>
                                <tr style="border-top: 1px solid black; border-bottom: 1px solid black;">
                                    <td style="text-align: left; padding-top: 6px; padding-bottom: 6px;">
                                        <asp:Label runat="server" ID="Label15" Text="Grand Total :"
                                            ForeColor="Black" Style="font-weight: 700; font-size: 16px;"></asp:Label>
                                    </td>
                                    <td style="text-align: right; padding-top: 6px; padding-bottom: 6px;">
                                        <asp:Label runat="server" ID="Label18" Text="0.00"
                                            ForeColor="Black" Style="font-weight: 700; font-size: 16px;"></asp:Label>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-sm-3"></div>
        </div>
    </div>
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            var disc = document.getElementById("<%= lbldiscount.ClientID %>");
            var row = document.getElementById("discountRow").parentElement;

            if (disc) {
                let value = disc.textContent.trim();

                if (value === "0" || value === "0.0" || value === "0.00") {
                    row.style.display = "none";
                }
            }
        });
    </script>

</asp:Content>

