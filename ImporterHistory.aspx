<%@ Page Title="" Language="C#" MasterPageFile="~/Home.master" AutoEventWireup="true" CodeFile="ImporterHistory.aspx.cs" Inherits="ImporterHistory" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

     <div class="col-md-12">

             <div class="box box-success">
            <div class="box-header">
              <h3 class="box-title">الموردين</h3>
                
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
                      var x = (from ss in db.importer where ss.roleType==roleType select new { ss}).ToList();
                      if (x != null)
                      {
                       %>
                <tr>
                  
                    <th>#</th>
                  <th>الاسم</th>
                 
                  <th>الهاتف</th>
                  <th>العنوان</th>
                  <th>الحساب</th>
                  <th>كميه </th>



                </tr>
                  <%int i = 1; foreach (var item in x)

                      { int x_id = int.Parse(item.ss.id.ToString());
                          var sumF = (from ff in db.importer_account where ff.importer_id == x_id select ff.daan).Sum();
                          var sump = (from ff in db.importer_account where ff.importer_id == x_id select ff.mdeen).Sum();
                         var qty = (from inv in db.import join it in db.import_items on inv.id equals it.imp_id where inv.importer_id == x_id select it.quantity).Sum();

                          if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["date1"])) && !String.IsNullOrEmpty(Convert.ToString(Request.QueryString["date2"])))
                          {   DateTime d1 = Convert.ToDateTime(Request.QueryString["date1"]);
                              DateTime d2 = Convert.ToDateTime(Request.QueryString["date2"]);
                              sumF = (from ff in db.importer_account where ff.importer_id == x_id && ff.date >= d1 && ff.date < d2 select ff.daan).Sum();
                              sump = (from ff in db.importer_account where ff.importer_id == x_id && ff.date >= d1 && ff.date < d2 select ff.mdeen).Sum();
                              qty = (from inv in db.import join it in db.import_items on inv.id equals it.imp_id where inv.importer_id == x_id && inv.date >= d1 && inv.date < d2 select it.quantity).Sum();

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

                         
                          if (qty == null)
                          {
                              q = 0;
                          }
                          else { q = double.Parse(qty.ToString()); }

                          double acc = p-f;
                          
                           %> 
                      
                <tr>
                     <td class="text-bold"><a  href="AccountImporter.aspx?id=<%=item.ss.id %>"> <% Response.Write(i); %></a></td>

                 <td><% Response.Write(item.ss.name); %></td>
                 
                 <td><% Response.Write(item.ss.phone); %></td>
                 <td><% Response.Write(item.ss.address); %></td>
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

