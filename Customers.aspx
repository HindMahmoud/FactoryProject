<%@ Page Title="" Language="C#" MasterPageFile="~/Home.master" AutoEventWireup="true" CodeFile="Customers.aspx.cs" Inherits="Customers" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="row">
        <div class="col-md-5 ">
            <div class="row box box-warning">
        <div class="col-md-12">
            اسم العميل
            <asp:TextBox CssClass="form-control" ID="client" runat="server"></asp:TextBox>
        </div>
        
        <div class="col-md-12">
            رقم الهاتف
            <asp:TextBox CssClass="form-control" ID="phone" runat="server"></asp:TextBox>
        </div>
         <div class="col-md-12">
           تاريخ الميلاد
            <asp:TextBox TextMode="Date" CssClass="form-control" ID="birthdate" runat="server"></asp:TextBox>
        </div>
                
          <div class="col-md-12">
           <br />
            <asp:Button CssClass="btn btn-success" OnClick="add_Click" ID="add" Text="اضافه" runat="server" style="margin-bottom:15px"></asp:Button>
              
        </div>
                
                </div>
            </div>
         <div class="col-md-7">

             <div class="box box-warning">
            <div class="box-header">
              <h3 class="box-title">العملاء</h3>
                
              <div class="box-tools">
                <div class="input-group input-group-sm" style="width: 150px;">
                  <input type="text" name="table_search" id="search" class="form-control pull-right" onkeyup="myFunction1()" placeholder="search..">

                  <%--<div class="input-group-btn">
                    <button type="submit" class="btn btn-default"><i class="fa fa-search"></i></button>
                  </div>--%>
                </div>
              </div>
            </div>
                 <br />
            <!-- /.box-header -->
            <div class="box-body table-responsive no-padding">
              <table class="table table-hover" id="mytable">
                  <% 
                      FactoryDBEntities db = new FactoryDBEntities();
                      DateTime d = DateTime.Now.Date;
                      var x = (from ss in db.customer where ss.roleType==roleType select ss).ToList();
                      if (x != null)
                      {
                       %>
                <tr>
                  
                    <th>#</th>
                  <th>الاسم</th>
                  <th>الهاتف</th>

                  <th>تاريخ الميلاد</th>
                
                  <th>الحساب</th>



                  
                
                  <th></th>
                 
                  <th></th>


                </tr>
                  <% int i = 1; foreach (var item in x)
                      {


                          int x_id = int.Parse(item.id.ToString());
                          var sumF = (from ff in db.customer_account where ff.customer_id == x_id select ff.total).Sum();
                          var sump = (from ff in db.customer_account where ff.customer_id == x_id select ff.pay).Sum();

                          var sumr = (from ff in db.customer_account where ff.customer_id == x_id select ff.repay).Sum();

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
                          DateTime dt = Convert.ToDateTime(item.date);



                           %> 
                      
                <tr>
            <td class="text-bold"><a  href="AccountCustomer.aspx?id=<%=item.id %>"> <% Response.Write(i); %></a></td>


                 <td class="text-black"><a  href="AccountCustomer.aspx?id=<%=item.id %>"><% Response.Write(item.name); %></a></td>
                 <td><% Response.Write(item.phone); %></td>
                 <td><% Response.Write(dt.Day+"/"+dt.Month+"/"+dt.Year); %>
                    <span>
                      <%if(((dt.Month)==DateTime.Now.Month)&&(dt.Day==DateTime.Now.Day)){%>
                      <span  style="font-size:14px;padding-right:3px" class="glyphicon glyphicon-gift text-danger"></span>
                     <% } %></span>
                 </td>
                 
                 <td><% Response.Write(acc); %></td>




                
                 
                    <td><a  href='Customers.aspx?editid=<%=item.id %>'>  <i class="fa fa-edit text-aqua"></i></a></td>
                    
                   <td><a  href='Customers.aspx?id=<%=item.id %>'>  <i class="fa fa-trash-o text-red"></i></a></td>


                    

                </tr>
                    <%  i++;
                            }
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
</asp:Content>

