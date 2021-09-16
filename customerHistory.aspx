<%@ Page Title="" Language="C#" MasterPageFile="~/Home.master" AutoEventWireup="true" CodeFile="customerHistory.aspx.cs" Inherits="customerHistory" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">


     <div class="col-md-12">

             <div class="box box-warning">
            <div class="box-header">
              <h3 class="box-title">العملاء</h3>
                
              <div class="box-tools">
                <div class="input-group input-group-sm" style="width: 150px;">
                 
                </div>
              </div>
            </div>
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
                  <th>كميه </th>

                </tr>
                  <% int i = 1; foreach (var item in x)
                      {


                          int x_id = int.Parse(item.id.ToString());
                          var sumF = (from ff in db.customer_account where ff.customer_id == x_id select ff.total).Sum();
                          var sump = (from ff in db.customer_account where ff.customer_id == x_id select ff.pay).Sum();

                          var sumr = (from ff in db.customer_account where ff.customer_id == x_id select ff.repay).Sum();


                          var qty = (from inv in db.invoice join it in db.invoice_items on inv.id equals it.inv_id where inv.customer_id == x_id select it.quantity).Sum();
                          if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["date1"])) && !String.IsNullOrEmpty(Convert.ToString(Request.QueryString["date2"])))
                          {
                              DateTime d1 = Convert.ToDateTime(Request.QueryString["date1"]);

                              DateTime d2 = Convert.ToDateTime(Request.QueryString["date2"]);


                              sumF = (from ff in db.customer_account where ff.customer_id == x_id && ff.date >= d1 && ff.date < d2 select ff.total).Sum();
                              sump = (from ff in db.customer_account where ff.customer_id == x_id && ff.date >= d1 && ff.date < d2 select ff.pay).Sum();

                              sumr = (from ff in db.customer_account where ff.customer_id == x_id && ff.date >= d1 && ff.date < d2 select ff.repay).Sum();


                              qty = (from inv in db.invoice join it in db.invoice_items on inv.id equals it.inv_id where inv.customer_id == x_id && inv.date >= d1 && inv.date < d2 select it.quantity).Sum();

                          }
                          double f, p, r,q;
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

                          if (qty == null)
                          {
                              q = 0;
                          }
                          else { q = double.Parse(qty.ToString()); }

                          double acc = f - (p + r);




                           %> 
                      
                <tr>
            <td class="text-bold">
               <%if (item.name != "كاش")
                   { %>
                 <a  href="AccountCustomer.aspx?id=<%=item.id %>">
                    
                     <% Response.Write(i); %>

                </a>
                <%}else Response.Write(i); %>
            </td>


                 <td> <%if (item.name != "كاش")
                          { %>
                 <a  href="AccountCustomer.aspx?id=<%=item.id %>">
                    
                     <% Response.Write(item.name); %>

                </a><%}else Response.Write(item.name); %>
                     </td>
                 <td><% Response.Write(item.phone); %></td>
                 <td><% Response.Write(item.date); %></td>
                 
                 <td><% Response.Write(acc); %></td>
                 <td><% Response.Write(q); %></td>



                </tr>
                    <%  i++;
                            }
                        }%>
               
              </table>
            </div>
            <!-- /.box-body -->
          </div>
         

         </div>


</asp:Content>

