<%@ Page Title="" Language="C#" MasterPageFile="~/Home.master" AutoEventWireup="true" CodeFile="profilebank.aspx.cs" Inherits="profilebank" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
   <%if (Session["role"] != null)
        {
            if (Session["role"].ToString() == "All permission")
            {


             %>
    <div class="row">
         <%  FactoryDBEntities db = new FactoryDBEntities();

             bank it = db.bank.FirstOrDefault(a => a.id == x);
             string s = x.ToString();
              %>
         <a href="addbank.aspx" class="glyphicon  glyphicon-circle-arrow-left  text-blue" style="font-size: 16px;
    margin-right: 642px;"><span style="font-family:Bahnschrift;color:blue;font-size:17px">رجوع</span></a>
        <div class="col-md-4">
            <div class="row">
                <div class="col-md-12">
                    <br />
            <div class="box box-primary">
            <div class="box-body box-profile">
             <h3 class="profile-username text-center"><%=it.BankName.ToString()%></h3>
               
             <ul class="list-group list-group-unbordered">
               
                  <li class="list-group-item bg-blue-gradient">
                      <%  var daansumation = (from ff in db.bank_account where ff.bank_id == s select ff.daan).Sum();
                          var mdeensumation = (from ff in db.bank_account where ff.bank_id == s select ff.mdeen).Sum();
                          

                          double ?acc =  daansumation-mdeensumation; %>
                      <b>حساب البنك $$ </b><span class="bg-red-gradient "><%=acc.ToString() %></span>
                  </li>

                  </ul>
                </div>
                </div>
                </div>
                
                <div class="col-md-12 box box-primary">
                    <div class="row">
                        <br />
                        <div class="col-md-12">
                            النوع: <asp:RequiredFieldValidator  ForeColor="Red" ValidationGroup="a" CssClass="text-red text-bold list-group-item-text" ControlToValidate="title" ID="RequiredFieldValidator1" runat="server" ErrorMessage=" اختار البيان"></asp:RequiredFieldValidator>
        
                            <asp:DropDownList  style="padding:0px" ToolTip="select" CssClass="form-control js-example-placeholder-single select2" ID="title" runat="server">
                                <asp:ListItem Value="1">ايداع</asp:ListItem>
                                <asp:ListItem Value="2">سحب</asp:ListItem>
                              
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-12">
                            المبلغ: <asp:RequiredFieldValidator  ForeColor="Red" ValidationGroup="a" CssClass="text-red text-bold list-group-item-text" ControlToValidate="value" ID="RequiredFieldValidator2" runat="server" ErrorMessage="ادخل القيمه"></asp:RequiredFieldValidator>
                         <asp:TextBox  TextMode="Number"  CssClass="form-control" ID="value" runat="server"></asp:TextBox>
                        </div>
                       
                        <div class="col-md-12 ">
                            <br/>
                            <asp:Button Text="اضافه"  CausesValidation="true" ValidationGroup="a" OnClick="btnadd_Click" CssClass="btn btn-primary" ID="btnadd" runat="server"></asp:Button>
                        <br />
                        </div>

                    </div>
                        
                 <br />                    
                 </div>
                </div>
            
        </div>
        <div class="col-md-8" style="overflow-y:auto;height:500px">

             <div class="box box-primary">
            <div class="box-header">
              <h3 class="box-title">كشف حساب</h3>

              <div class="box-tools">
                <div class="input-group input-group-sm" style="width: 150px;">
                  <input type="text" name="table_search" id="search" class="form-control pull-right" onkeyup="myFunction1()" placeholder="Search">

                </div>
              </div>
            </div>
            <!-- /.box-header -->
            <div class="box-body table-responsive no-padding">
              <table class="table table-hover" id="mytable">
                  <% 

                      var lab = (from ss in db.bank_account where ss.bank_id == s select ss).ToList();
                      if (lab != null)
                      {
                       %>
                <tr>
                  <th>#</th>
                  <th>التاريخ</th>
                  <th>البيان</th>
                  <th>دائن </th>
                  <th>مدين</th>
                 
                  <th></th>
                  <th></th>
                </tr>
                  <% int i = 1; foreach (var item in lab)
                      {
                           %> 
                      
                <tr>
                 <td> <% Response.Write(i); %></td>
                 <td><% Response.Write(Convert.ToDateTime(item.datep.ToString())); %></td>
                 <td><% Response.Write(item.title); %></td>

                 <td><% Response.Write(item.daan); %></td>
                 <td><% Response.Write(item.mdeen); %></td>
               
                 <td><a href="profilebank.aspx?id=<%=item.bank_id %>&&del=<%=item.id %>">  <i class="fa fa-trash-o text-red"></i></a></td>
                 <td><a href="profilebank.aspx?id=<%=item.bank_id %>&&edit=<%=item.id %>">  <i class="fa fa-edit text-blue"></i></a></td>
                </tr>
                    <%  i++;
                            }
                        }
                       %>
               
              </table>
            </div>
            <!-- /.box-body -->
          </div>
          </div>
    </div>
    <script>

        function myFunction1() {
            var input, filter, table, tr, td, i;
            input = document.getElementById("search");
            filter = input.value.toUpperCase();
            table = document.getElementById("mytable");
            tr = table.getElementsByTagName("tr");
            for (i = 0; i < tr.length; i++) {
                td = tr[i].getElementsByTagName("td")[1];
                if (td) {
                    if (td.innerHTML.toUpperCase().indexOf(filter) > -1) {
                        tr[i].style.display = "";
                    } else {
                        tr[i].style.display = "none";
                    }
                }
            }
        }
    </script>
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


