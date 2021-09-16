<%@ Page Title="" Language="C#" MasterPageFile="~/Home.master" AutoEventWireup="true" CodeFile="AccountCustomer.aspx.cs" Inherits="AccountCustomer" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    
    <script type="text/javascript">

         $(function () {
             initdropdown();
         })
         function initdropdown() {
            $(".js-example-placeholder-single").select2({
                placeholder: "...اختار",
                allowClear: true
            });
        };
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <%if (Session["role"] != null)
        {
            if (Session["role"].ToString() == "All permission")
            {


             %>
    <div class="row">
         <%  FactoryDBEntities db = new FactoryDBEntities();
             int x=0;
             if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["id"])))
             {
                 x = int.Parse(Request.QueryString["id"].ToString());
             }
             customer it = db.customer.FirstOrDefault(a => a.id == x);
             if (it.name == "كاش")
             { Response.Write("<script>alert('لا يوجد حساب')</script>");return; }
              %>
        <div class="col-md-4">
            <div class="row">
                <div class="col-md-12">
            <div class="box box-warning">
            <div class="box-body box-profile">
              
              <h3 class="profile-username text-center"><%=it.name.ToString()%></h3>
              <ul class="list-group list-group-unbordered">
                <li class="list-group-item">
                  <b>الهاتف: </b><span class="text-blue"><%=it.phone.ToString() %></span>
                </li>
                  <li class="list-group-item">
                      <%DateTime dt = Convert.ToDateTime(it.date);%>
                 <b>تاريخ الميلاد: </b><span class="text-blue"><%=(dt.Day+"/"+dt.Month+"/"+dt.Year) %><%if(((dt.Month)==DateTime.Now.Month)&&(dt.Day==DateTime.Now.Day)){%>
                      <span  style="font-size:30px;padding-right:3px" class="glyphicon glyphicon-gift text-danger"></span>
                     <% } %></span>
                 


                </li>
                  <li class="list-group-item bg-yellow">
                      <% var sumF = (from ff in db.customer_account where ff.customer_id == x select ff.total).Sum();
                          var sump = (from ff in db.customer_account where ff.customer_id == x select ff.pay).Sum();

                          var sumr = (from ff in db.customer_account where ff.customer_id == x select ff.repay).Sum();

                          double f, p, r;
                          if (sumF == null)
                          {
                              f = 0;
                          }
                          else {
                              f = double.Parse(sumF.ToString());
                          }

                          if (sump == null)
                          {
                              p = 0;
                          }
                          else { p = double.Parse(sump.ToString()); }

                          if (sumr == null)
                          {
                              r = 0;
                          }
                          else { r = double.Parse(sumr.ToString()); }

                          double acc = f - (p + r);


                            %>
                      <b>حساب العميل $$ </b><span class="bg-purple-gradient "><%=acc.ToString() %></span>
                  </li>

                  </ul>
                </div>
                </div>
                </div>
                
                <div class="col-md-12 box box-warning">
                    <div class="row">
                        <br />

                        <div class="col-md-12">
                            البيان:<span class="star-validation">*</span>
                            <asp:DropDownList  ToolTip="select" CssClass="form-control js-example-placeholder-single select2" ID="title" runat="server">
                                <asp:ListItem>فاتوره</asp:ListItem>
                                <asp:ListItem>سداد</asp:ListItem>
                                <asp:ListItem>مرتجع</asp:ListItem>
                            </asp:DropDownList>
                              <asp:RequiredFieldValidator ID="valtxtValidator" runat="server"
                                        ControlToValidate="title" ErrorMessage="اختار البيان" ForeColor="Red"></asp:RequiredFieldValidator>
                        </div>
                        <div class="col-md-12">
                            القيمه:<span class="star-validation">*</span>
                            <asp:TextBox CssClass="form-control" ID="value" runat="server"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server"
                                        ControlToValidate="value" ErrorMessage=" القيمه مطلوبة" ForeColor="Red"></asp:RequiredFieldValidator>
                       
                        </div>
                        
                        <div class="col-md-12">
                            
                            <asp:RadioButtonList AutoPostBack="true" OnSelectedIndexChanged="RadioButtonList1_SelectedIndexChanged" ID="RadioButtonList1" runat="server" RepeatDirection="Horizontal">
                                <asp:ListItem Selected="True">خزينه</asp:ListItem>
                                <asp:ListItem>بنك</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                         <div class="col-md-12">
                             <asp:DropDownList Visible="False" CssClass="form-control js-example-placeholder-single select2"  AppendDataBoundItems="True" ID="importerss" runat="server" DataSourceID="SqlDataSource1" DataTextField="name" DataValueField="id">
                                 <asp:ListItem></asp:ListItem>
                             </asp:DropDownList>

                             <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:FactoryDBConnectionString %>" SelectCommand="SELECT [id], [name] FROM [importer]"></asp:SqlDataSource>
                          <asp:DropDownList Visible="False" CssClass="form-control js-example-placeholder-single select2"  AppendDataBoundItems="True" ID="DropDownList1" runat="server" DataSourceID="SqlDataSource2" DataTextField="BankName" DataValueField="id">
                                 <asp:ListItem></asp:ListItem>
                             </asp:DropDownList>
                             <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:FactoryDBConnectionString %>" SelectCommand="SELECT [BankName], [id] FROM [bank]"></asp:SqlDataSource>
                             </div>
                        <div class="col-md-12"><asp:FileUpload AllowMultiple="true" ID="FileUpload1" runat="server" /><br />
                                                               
                                </div>
                        <div class="col-md-12 ">
                            <br/>
                            <asp:Button Text="اضافه" OnClick="btnadd_Click" CssClass="btn btn-warning" ID="btnadd" runat="server"></asp:Button>
                        <br />
                        </div>

                    </div>
                        
<br />                    
               

          

                </div>
                </div>
            
        </div>
        <div class="col-md-8" style="overflow-y:auto;height:500px">

             <div class="box box-warning">
            <div class="box-header">
              <h3 class="box-title">كشف حساب</h3>

              <div class="box-tools">
                <div class="input-group input-group-sm" style="width: 150px;">
                 
                </div>
              </div>
            </div>
            <!-- /.box-header -->
            <div class="box-body table-responsive no-padding">
              <table class="table table-hover" id="mytable">
                  <% 

                      var lab = (from ss in db.customer_account where ss.customer_id == x  select ss).ToList();
                      if (lab != null)
                      {
                       %>
                <tr>
                  <th>#</th>
                  <th>التاريخ</th>
                  <th>البيان</th>

                  <th>فاتوره </th>
                  <th>سداد</th>
                  <th> مرتجعات</th>
                  <th> صوره</th>

                 


               
                  <th></th>
                  


                </tr>
                  <% int i = 1;
                      foreach (var item in lab)
                      {
                           %> 
                      
                <tr>
                    <td> <% Response.Write(i); %></td>
                 <td><% Response.Write(Convert.ToDateTime(item.date.ToString())); %></td>
                 <td><% Response.Write(item.title); %></td>

                 <td><% Response.Write(item.total); %></td>
                 <td><% Response.Write(item.pay); %></td>
                 <td><% Response.Write(item.repay); %></td>
                 <%if (item.img != null)
                     { %>
                    <td><a href='photos/<%=item.img %>' target="_blank"><i class="fa fa-file-image-o"></i></a></td>
                    <%}
    else {  %><td></td><%} %>
         <td><a href="AccountCustomer.aspx?id=<%=item.customer_id %>&&delinv=<%=item.id %>">  <i class="fa fa-trash-o text-red"></i></a></td>
        <%-- <td><a href="AccountCustomer.aspx?id=<%=item.customer_id %>&&print=<%=item.id %>">  <i class="fa fa-print text-blue"></i></a></td>
      --%></tr>
                    <%  i++;
                            }
                        }
                       %>
               
              </table>
            </div>
            <!-- /.box-body -->
          </div>
         
        </div>

        <div class="col-md-8" style="overflow-y:auto;height:500px">
               <div class="box">
            <div class="box-header">
              <h3 class="box-title">فواتير </h3>
                
              <div class="box-tools">
                <div class="input-group input-group-sm" style="width: 150px;">
               
                </div>
              </div>
            </div>
            <!-- /.box-header -->
            <div class="box-body table-responsive no-padding">
              <table class="table table-hover" id="mytable2">
                  <% 
                      
                      var xx = (from ss in db.invoice where ss.customer_id==x where ss.id !=0 select ss).ToList();
                      if (xx != null)
                      {
                       %>
                <tr>
                  
                    <th>الفاتوره#</th>
                    <th>التاريخ#</th>
                    <th>العميل</th>


                  <th>الاجمالي</th>
                  
                
                  <th>نسبه الخصم %</th>
                 
                  <th>الاجمالي بعد الخصم</th>
                 <th>صوره</th>
                </tr>
                  <% foreach (var item in xx)
    {
                           DateTime dd = Convert.ToDateTime(item.date);
                          string ddd = dd.ToString("yyyy/MM/dd");
                           %> 
                      
                <tr>
                   <td class="text-bold  fa fa-share" style="font-size:large"> <a href="editInvoice.aspx?id=<%=item.id %>"><% Response.Write(item.id); %></a></td>

                 <td><% Response.Write(ddd); %></td>
                 <td><% Response.Write(item.customer_name); %></td>

                 
                 <td><% Response.Write(item.total); %></td>
                 <td><% Response.Write(item.discount); %></td>
                
                 <td><% Response.Write(item.Nettotal); %></td>
                 
                     <%if (item.img != null)
                     { %>
                    <td><a href='photos/<%=item.img %>' target="_blank"><i class="fa fa-file-image-o"></i></a></td>
                    <%}
    else {  %><td></td><%} %>
         
                 
                   <td><a  href='AccountCustomer.aspx?id=<%=x %>&&invprint=<%=item.id %>'>  <i class="fa fa-print text-blue"></i></a></td>
                    
                   <td><a  href='AccountCustomer.aspx?id=<%=x %>&&invdelete=<%=item.id %>'>  <i class="fa fa-trash-o text-red"></i></a></td>


                    

                </tr>
                    <%  }
    }%>
               
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


