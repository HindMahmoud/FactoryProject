<%@ Page Title="" Language="C#" MasterPageFile="~/Home.master" AutoEventWireup="true" CodeFile="adduser.aspx.cs" Inherits="adduser" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <%if (Session["role"] != null)
        {
            if (Session["role"].ToString() == "All permission")
            {


             %>
    <div class="row" style="background-color:white;padding-bottom:5px">
        <div class="col-md-3">
          الاسم :<span class="star-validation">*</span>
            <asp:RequiredFieldValidator ID="RequiredFieldValidator5" ValidationGroup="s1" runat="server" ErrorMessage="ادخل الاسم" ControlToValidate="n"  ForeColor="red"></asp:RequiredFieldValidator>
           <asp:TextBox   CssClass="form-control" ID="n" runat="server"></asp:TextBox>
        </div>
         <div class="col-md-3">
          اسم المستخدم:<span class="star-validation">*</span>
           <asp:RequiredFieldValidator ID="RequiredFieldValidator2" ValidationGroup="s1" runat="server" ErrorMessage="ادخل اسم المستخدم" ControlToValidate="name"  ForeColor="red"></asp:RequiredFieldValidator>
             <asp:TextBox   CssClass="form-control" ID="name" runat="server"></asp:TextBox>
        </div>
        <div class="col-md-3">
          الرقم السري:<span class="star-validation">*</span>
            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" ValidationGroup="s1" runat="server" ErrorMessage="ادخل الرقم السري" ControlToValidate="password"  ForeColor="red"></asp:RequiredFieldValidator>
            <asp:TextBox   CssClass="form-control" ID="password" runat="server"></asp:TextBox>
        </div>
         <div class="col-md-3">
          الصلاحيه:<span class="star-validation">*</span>
              <asp:RequiredFieldValidator ID="RequiredFieldValidator3" ValidationGroup="s1" runat="server" ErrorMessage="اختر الصلاحية" ControlToValidate="role"  ForeColor="red"></asp:RequiredFieldValidator>
             <asp:DropDownList  CssClass="form-control" ID="role" runat="server" AppendDataBoundItems="True">
                <asp:ListItem></asp:ListItem>
                <asp:ListItem>All permission</asp:ListItem>
                <asp:ListItem>Specific permission</asp:ListItem>
            </asp:DropDownList>
        </div>
         <div class="col-md-3">
          المكان:<span class="star-validation">*</span>
              <asp:RequiredFieldValidator ID="RequiredFieldValidator4" ValidationGroup="s1" runat="server" ErrorMessage="اختر المكان" ControlToValidate="ddl"  ForeColor="red"></asp:RequiredFieldValidator>
             <asp:DropDownList  CssClass="form-control" ID="ddl" runat="server" style="padding:0px" AppendDataBoundItems="True">
                <asp:ListItem Value="Factory">مصنع</asp:ListItem>
                <asp:ListItem Value="other">اخري</asp:ListItem>
              
            </asp:DropDownList>
        </div>
        <div class="col-md-12 text-center">
            <br />
            <asp:Button CssClass="btn btn-success" ValidationGroup="s1" CausesValidation="true" OnClick="Button1_Click" ID="Button1" runat="server" Text="اضافه" />
        <br />
       <br />
       <br />
             </div>
      
        <div class="col-md-12">
        <asp:GridView Width="80%"   ID="GridView1" runat="server" AutoGenerateColumns="False" DataKeyNames="id" DataSourceID="SqlDataSource1" AllowPaging="True" CellPadding="4" ForeColor="#333333" GridLines="None" AllowSorting="True">
            <AlternatingRowStyle BackColor="White" />
            <Columns>
              
                <asp:BoundField DataField="id" HeaderText="id" ReadOnly="True" InsertVisible="False" SortExpression="id"></asp:BoundField>
                <asp:BoundField DataField="name" HeaderText="name" SortExpression="name"></asp:BoundField>

                <asp:BoundField DataField="user_name" HeaderText="user_name" SortExpression="user_name"></asp:BoundField>
                <asp:BoundField DataField="password" HeaderText="password" SortExpression="password"></asp:BoundField>
                <asp:BoundField DataField="role" HeaderText="role" SortExpression="role"></asp:BoundField>
                <asp:BoundField DataField="typeRole" HeaderText="typeRole" SortExpression="typeRole"></asp:BoundField>
                  <asp:CommandField ShowDeleteButton="True" ShowEditButton="True" />
            </Columns>
            <EditRowStyle BackColor="#7C6F57" />

            <FooterStyle BackColor="#1C5E55" Font-Bold="True" ForeColor="White"></FooterStyle>

            <HeaderStyle BackColor="#1C5E55" Font-Bold="True" ForeColor="White"></HeaderStyle>

            <PagerStyle HorizontalAlign="Center" BackColor="#666666" ForeColor="White"></PagerStyle>

            <RowStyle BackColor="#E3EAEB"></RowStyle>

            <SelectedRowStyle BackColor="#C5BBAF" Font-Bold="True" ForeColor="#333333"></SelectedRowStyle>

            <SortedAscendingCellStyle BackColor="#F8FAFA"></SortedAscendingCellStyle>

            <SortedAscendingHeaderStyle BackColor="#246B61"></SortedAscendingHeaderStyle>

            <SortedDescendingCellStyle BackColor="#D4DFE1"></SortedDescendingCellStyle>

            <SortedDescendingHeaderStyle BackColor="#15524A"></SortedDescendingHeaderStyle>
        </asp:GridView>

            <%--<asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:FactoryDBConnectionString %>" SelectCommand="SELECT * FROM [users]"></asp:SqlDataSource>
                 --%>
            <asp:SqlDataSource runat="server" ID="SqlDataSource1" ConnectionString='<%$ ConnectionStrings:FactoryDBConnectionString %>' SelectCommand="SELECT * FROM [users]" DeleteCommand="DELETE FROM [users] WHERE [id] = @id" InsertCommand="INSERT INTO [users] ([name], [user_name], [password], [role],[typeRole]) VALUES (@name, @user_name, @password, @role,@typeRole)" UpdateCommand="UPDATE [users] SET [name] = @name, [user_name] = @user_name, [password] = @password, [role] = @role,[typeRole]=@typeRole WHERE [id] = @id">
                 <DeleteParameters>
                <asp:Parameter Name="id" Type="Int32"></asp:Parameter>
            </DeleteParameters>
            <InsertParameters>
                <asp:Parameter Name="name" Type="String"></asp:Parameter>
                <asp:Parameter Name="user_name" Type="String"></asp:Parameter>
                <asp:Parameter Name="password" Type="String"></asp:Parameter>
                <asp:Parameter Name="role" Type="String"></asp:Parameter>
                 <asp:Parameter Name="typeRole" Type="String"></asp:Parameter>
            </InsertParameters>
            <UpdateParameters>
                <asp:Parameter Name="name" Type="String"></asp:Parameter>
                <asp:Parameter Name="user_name" Type="String"></asp:Parameter>
                <asp:Parameter Name="password" Type="String"></asp:Parameter>
                <asp:Parameter Name="role" Type="String"></asp:Parameter>
                 <asp:Parameter Name="typeRole" Type="String"></asp:Parameter>
                <asp:Parameter Name="id" Type="Int32"></asp:Parameter>
            </UpdateParameters>
            </asp:SqlDataSource>
            <%--<asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:FactoryDBConnectionString %>" SelectCommand="SELECT * FROM [users]" ></asp:SqlDataSource>
        --%>
            </div>
     <%--   <div class="col-md-4 box box-primary">
            <div class="col-md-6">
            ضريبه القيمه المضافه %
            <asp:TextBox ID="extraper" Text="0" CssClass="form-control" runat="server"></asp:TextBox>
                </div>
            <div class="col-md-6">
            الخصم %
            <asp:TextBox ID="TextBox1" Text="0" CssClass="form-control" runat="server"></asp:TextBox>
                </div>
            <div class="col-md-2">
               <br />
                <asp:Button ID="taxes" OnClick="taxes_Click" class="btn btn-success" runat="server" Text="حفظ" />
            <br />
            <br />
            </div>
            

        </div>--%>
    </div>
     <% }
           else
           {
               %><div   style="font-weight:bold"  class="text-center text-danger">ليس لديك صلاحيه لدخول الصفحه</div><%
           }
       }

       else
       {
           Response.Redirect("login.aspx");
       }%>
</asp:Content>

