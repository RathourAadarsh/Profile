<%@ Page Title="" Language="C#" MasterPageFile="~/HomeMAster.master" AutoEventWireup="true" CodeFile="Item_Master.aspx.cs" Inherits="Item_Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style>
        .form-control {
            height: 31px;
        }

        .pt-5, .py-5 {
            padding-top: 1.5rem !important;
        }

        #imgProfile {
            width: 100px;
            height: 100px;
            object-fit: cover;
        }

        tr {
            height: 35px;
        }
         .form-group {
     margin-bottom: 8px;
 }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="container" style="margin-top: 40px;margin-block:10px;">
        <div class="col-md-12">
            <div class="row">
                <div class="col-md-5" style="box-shadow: 1px 1px 5px 1px #05300a; border-radius: 7px;">
                    <div class="form-group">
                        <div class="row">
                            <div class="col-md-12">
                                <h5 style="text-align: center; padding-top: 10px; color: brown;">Subcategory Master</h5>
                            </div>
                        </div>
                    </div>
                    <hr />
                    <div class="form-group">
                        <div class="row">
                            <div class="col-md-1"></div>
                            <div class="col-md-4">
                                <asp:Label runat="server" ID="Label1" Text="Item Group" ForeColor="Black"></asp:Label>
                            </div>
                            <div class="col-md-6">
                                <asp:DropDownList runat="server" ID="ddlitemgroup" Class="form-control"></asp:DropDownList>
                            </div>
                            <div class="col-md-1"></div>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="row">
                            <div class="col-md-1"></div>
                            <div class="col-md-4">
                                <asp:Label runat="server" ID="gname" Text="Item Name" ForeColor="Black"></asp:Label>
                            </div>
                            <div class="col-md-6">
                                <asp:TextBox runat="server" ID="txtitemname" class="form-control"></asp:TextBox>
                            </div>
                            <div class="col-md-1"></div>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="row">
                            <div class="col-md-1"></div>
                            <div class="col-md-4">
                                <asp:Label runat="server" ID="Label4" Text="SKU" ForeColor="Black"></asp:Label>
                            </div>
                            <div class="col-md-6">
                                <asp:TextBox runat="server" ID="txtitemsku" class="form-control"></asp:TextBox>
                            </div>
                            <div class="col-md-1"></div>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="row">
                            <div class="col-md-1"></div>
                            <div class="col-md-4">
                                <asp:Label runat="server" ID="Label2" Text="Rate" ForeColor="Black"></asp:Label>
                            </div>
                            <div class="col-md-6">
                                <asp:TextBox runat="server" ID="txtrate" class="form-control" Text="0.00"></asp:TextBox>
                            </div>
                            <div class="col-md-1"></div>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="row">
                            <div class="col-md-1"></div>
                            <div class="col-md-4">
                                <asp:Label runat="server" ID="Label3" Text="Unit" ForeColor="Black"></asp:Label>
                            </div>
                            <div class="col-md-6">
                                <asp:TextBox runat="server" ID="txtunit" class="form-control"></asp:TextBox>
                            </div>
                            <div class="col-md-1"></div>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="row">
                            <div class="col-md-1"></div>
                            <div class="col-md-4">
                                <asp:Label runat="server" ID="La" Text="Product Image" ForeColor="Black"></asp:Label>
                            </div>
                            <div class="col-md-6">
                                <asp:FileUpload ID="fuProfile" runat="server" CssClass="form-control p-1" Style="height: 40px;" accept=".jpg,.jpeg,.png" onchange="previewImage(this, 'imgProfile')" />
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="row mb-2">
                            <div class="col-md-5"></div>
                            <div class="col-md-4">
                                <img id="imgProfile" class="img-preview" />
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="row">
                                <div class="col-md-5"></div>
                                <div class="col-md-6">
                                    <asp:Button runat="server" ID="btnsave" Text="Save" Class="btn btn-success" Font-Bold="true" OnClick="btnsave_Click" Width="80px" />
                                    <asp:Button runat="server" ID="btncancel" Text="Cancel" Class="btn btn-danger" Font-Bold="true" OnClick="btncancel_Click" />
                                </div>
                                <div class="col-md-1"></div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-7">

                    <asp:Panel runat="server" ID="panel" Style="box-shadow: 0px 1px 5px 0px #05300a; border-radius: 7px; height: 450px; overflow: scroll;">
                        <div class="m-2">
                            <asp:GridView runat="server" ID="grid1" AutoGenerateColumns="False" Width="100%" BackColor="White" BorderColor="#336666" BorderStyle="Double" GridLines="Horizontal" Font-Size="12px">
                                <Columns>
                                    <asp:TemplateField HeaderText="Sr.No" HeaderStyle-Width="7%">
                                        <ItemTemplate><%#Container.DataItemIndex+1 %></ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Item Name" HeaderStyle-Width="23%">
                                        <ItemTemplate>
                                            <asp:Label runat="server" ID="lbliname" Text='<%#Eval("Item_Name")%>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Item Group" HeaderStyle-Width="22%">
                                        <ItemTemplate>
                                            <asp:Label runat="server" ID="lblgname" Text='<%#Eval("Item_Group_Name")%>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Restaurent Rate" HeaderStyle-Width="20%">
                                        <ItemTemplate>
                                            <asp:Label runat="server" ID="lblrestrate" Text='<%#Eval("item_sale_rate")%>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="SKU" HeaderStyle-Width="9%">
                                        <ItemTemplate>
                                            <asp:Label runat="server" ID="lblsku" Text='<%#Eval("SKU")%>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Unit" HeaderStyle-Width="10%">
                                        <ItemTemplate>
                                            <asp:Label runat="server" ID="lblunit" Text='<%#Eval("item_unit")%>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Product Image">
        <ItemTemplate>
            <img src='<%# Eval("Productimage") %>'
                width="50"
                class="profile-thumb"
                onclick="showImagePopup(this.src)" />
        </ItemTemplate>
    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Edit" HeaderStyle-Width="9%">
                                        <ItemTemplate>
                                            <asp:ImageButton runat="server" ID="imgedit" ImageUrl="images/edit.png" OnClick="imgedit_Click" Height="18px" />
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                </Columns>
                                <FooterStyle BackColor="White" ForeColor="#333333" />
                                <HeaderStyle BackColor="#e9a889" Font-Bold="True" ForeColor="Black" />
                                <PagerStyle BackColor="#336666" ForeColor="White" HorizontalAlign="Center" />
                                <RowStyle BackColor="White" ForeColor="#333333" />
                                <SelectedRowStyle BackColor="#339966" Font-Bold="True" ForeColor="White" />
                                <SortedAscendingCellStyle BackColor="#F7F7F7" />
                                <SortedAscendingHeaderStyle BackColor="#487575" />
                                <SortedDescendingCellStyle BackColor="#E5E5E5" />
                                <SortedDescendingHeaderStyle BackColor="#275353" />
                            </asp:GridView>
                        </div>
                    </asp:Panel>
                </div>

            </div>
        </div>
    </div>
    <script>
        function previewImage(input, imgId) {
            const file = input.files[0];
            const img = document.getElementById(imgId);
            if (!file) return;
            const reader = new FileReader();
            reader.onload = e => {
                img.src = e.target.result;
                img.style.display = "block";
            };
            reader.readAsDataURL(file);
        }
    </script>
</asp:Content>

