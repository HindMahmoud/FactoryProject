<%@ Page Title="" Language="C#" MasterPageFile="~/Home.master" AutoEventWireup="true" CodeFile="profitSearch.aspx.cs" Inherits="profitSearch" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <%if (Session["role"] != null)
        {
            if (Session["role"].ToString() == "All permission")
            {


             %>
    
     <div class="col-md-12">

             <div class="box box-info">
            <div class="box-header">
              <h3 class="box-title">المبيعات</h3>
                
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
                      DateTime dplus = d.AddDays(1);

                      var   x = (from s in db.invoice_items
                                 join ss in db.invoice on s.inv_id equals ss.id

                                 where ss.date>=d && ss.date<dplus&&ss.typeRole==roleType  group s by new { s.prod_name,s.prod_code } into g select new {c=g.Key.prod_code, n = g.Key.prod_name, qty = g.Sum(a => a.quantity) ,summ=g.Sum(a=>a.NetTotal)}).ToList();


                      if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["date1"])) && !String.IsNullOrEmpty(Convert.ToString(Request.QueryString["date2"])))
                      {
                          DateTime d1 = Convert.ToDateTime(Request.QueryString["date1"]);

                          DateTime d2 = Convert.ToDateTime(Request.QueryString["date2"]);
                          x = (from s in db.invoice_items
                               join ss in db.invoice on s.inv_id equals ss.id

                               where ss.date >= d1 && ss.date < d2&&ss.typeRole==roleType
                               group s by new { s.prod_name, s.prod_code } into g
                               select new { c = g.Key.prod_code, n = g.Key.prod_name, qty = g.Sum(a => a.quantity), summ = g.Sum(a => a.NetTotal) }).ToList();

                      }
                      if (x != null)
                      {
                       %>
                <tr>
                  
                    <th>#</th>
                  <th>الكود</th>
                 
                  <th>الاسم</th>

                  <th>الكميه</th>
                  <th>اجمالي البيع</th>
                  <th>اجمالي التكلفه</th>

                  <th>الربح </th>



                </tr>
                  <%int i = 1; foreach (var item in x)

                      {
                          string code = item.c.ToString();
                          double p = double.Parse(item.summ.ToString());
                          double q = double.Parse(item.qty.ToString());

                          var sst = (from st in db.stock where st.code == code select st).FirstOrDefault();
                          double bp = double.Parse(sst.buy_price.ToString());
                          double total_buy = bp * q;
                          double total = double.Parse(item.summ.ToString()) - total_buy;


                           %> 
                      
                <tr>
                     <td class="text-bold"><% Response.Write(i); %></td>

                 <td><% Response.Write(item.c); %></td>
                 
                 <td><% Response.Write(item.n); %></td>
                 <td><% Response.Write(item.qty); %></td>
                 <td><% Response.Write(item.summ); %></td>
                 <td><% Response.Write(total_buy); %></td>
                 <td><% Response.Write(total); %></td>


                 


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

