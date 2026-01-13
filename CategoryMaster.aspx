<%@ Page Title="" Language="C#" MasterPageFile="~/HomeMaster.master" AutoEventWireup="true" CodeFile="CategoryMaster.aspx.cs" Inherits="CategoryMaster" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style>
        body {
            color: black;
        }

        .form-group {
            margin-bottom: 8px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="container">
        <main class="main">
            <div class="form-group">
                <div class="row">
                    <div class="col-md-5" style="border: 1px solid; margin-top: 20px;">
                        <div class="form-group">
                            <div class="row">
                                <div class="col-md-12">
                                    <h5 style="text-align: center;padding:12px;font-weight:600;">Category Master</h5>
                                </div>
                            </div>
                        </div>
                        <hr />
                        <div class="form-group">
                            <div class="row">
                                <div class="col-md-1"></div>
                                <div class="col-md-4">
                                    <asp:Label runat="server" ID="llfas" Text="Category ID" ForeColor="Black"></asp:Label>
                                </div>
                                <div class="col-md-6">
                                    <asp:TextBox runat="server" ID="txtcateid" CssClass="form-control"></asp:TextBox>
                                </div>
                                <div class="col-md-1"></div>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="row">
                                <div class="col-md-1"></div>
                                <div class="col-md-4">
                                    <asp:Label runat="server" ID="Label1" Text="Category Name" ForeColor="Black"></asp:Label>
                                </div>
                                <div class="col-md-6">
                                    <asp:TextBox runat="server" ID="tcatename" CssClass="form-control"></asp:TextBox>
                                </div>
                                <div class="col-md-1"></div>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="row">
                                <div class="col-md-5"></div>
                                <div class="col-md-6">
                                    <asp:Button runat="server" ID="btnsave" Text="Save" CssClass="btn btn-success" OnClick="btnsave_Click"></asp:Button>
                                    <asp:Button runat="server" ID="Button1" Text="Back" CssClass="btn btn-danger" OnClick="Button1_Click"></asp:Button>
                                </div>
                                <div class="col-md-1"></div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-7"></div>
                </div>
            </div>
        </main>
    </div>
</asp:Content>

