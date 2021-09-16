<%@ Page Title="" Language="C#" MasterPageFile="~/Home.master" AutoEventWireup="true" CodeFile="dailyReport.aspx.cs" Inherits="dailyReport" %>

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
        <% 
    if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["date1"])) && !String.IsNullOrEmpty(Convert.ToString(Request.QueryString["date2"])))
    {
        DateTime d1 = Convert.ToDateTime(Request.QueryString["date1"]);
        DateTime d2 = Convert.ToDateTime(Request.QueryString["date2"]);
        string a = Convert.ToString(Request.QueryString["date1"]);
        string b = Convert.ToString(Request.QueryString["date2"]);
                     %>
        <h2><%=a %> : <%=b %></h2>

        <%}
    else
    { %>
        <h2><%=DateTime.Now.Date.ToShortDateString() %></h2>

        <%} %>
                <div class="col-md-3 col-xs-6">
        <div class="small-box bg-green-gradient">
            <div class="inner">
                <%  FactoryDBEntities db = new FactoryDBEntities();
                    DateTime today = DateTime.Now.Date;
                    DateTime todayplus = today.AddDays(1);

                    var inv = (from r in db.invoice where r.date >= today && r.date< todayplus&&r.typeRole==roleType select r.Nettotal);

                    if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["date1"]))&&!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["date2"])))
                    {
                        DateTime d1 = Convert.ToDateTime(Request.QueryString["date1"]);
                        DateTime d2 = Convert.ToDateTime(Request.QueryString["date2"]);

                        inv = (from r in db.invoice where r.date >= d1 && r.date< d2&&r.typeRole==roleType select r.Nettotal);


                    }
                    double suminv = 0;
                    if (inv.Sum() != null)
                    {
                        suminv = double.Parse(inv.Sum().ToString());
                    }
                     %>
              <h3><% Response.Write(suminv); %></h3>

              <p>اجمالي فواتير بيع </p>
            </div>
            <div class="icon">
              <i class="fa fa-dollar"></i>
            </div>
            <span  class="small-box-footer"><%=inv.Count() %> <i class="fa fa-arrow-circle-left"></i></span>
           
            </div>
            </div>



          <div class="col-md-3 col-xs-6">
        <div class="small-box bg-red-gradient">
            <div class="inner">
                <%
                    var imp = (from r in db.import where r.date >= today && r.date<todayplus select r.Net_total);
                    if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["date1"])) && !String.IsNullOrEmpty(Convert.ToString(Request.QueryString["date2"])))
                    {
                        DateTime d1 = Convert.ToDateTime(Request.QueryString["date1"]);
                        DateTime d2 = Convert.ToDateTime(Request.QueryString["date2"]);
                     imp = (from r in db.import where r.date >= d1 && r.date<d2 select r.Net_total);

                    }
                    double sumimp = 0;
                    if (imp.Sum() != null)
                    {
                        sumimp = double.Parse(imp.Sum().ToString());
                    }
                     %>
              <h3><% Response.Write(sumimp); %></h3>

              <p>اجمالي فواتير الشراء </p>
            </div>
            <div class="icon">
              <i class="fa fa-dollar"></i>
            </div>
            <span  class="small-box-footer"><%=imp.Count() %> <i class="fa fa-arrow-circle-left"></i></span>
           
            </div>
            </div>

        <div class="col-md-3 col-xs-6">
        <div class="small-box bg-red-gradient">
            <div class="inner">
                <%
                    var retu = (from r in db.returninv where r.date >= today && r.date <todayplus select r.total);
                    if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["date1"])) && !String.IsNullOrEmpty(Convert.ToString(Request.QueryString["date2"])))
                    {
                        DateTime d1 = Convert.ToDateTime(Request.QueryString["date1"]);
                        DateTime d2 = Convert.ToDateTime(Request.QueryString["date2"]);
                     retu = (from r in db.returninv where r.date >= d1 && r.date <d2 select r.total);

                    }
                    double sumret = 0;
                    if (retu.Sum() != null)
                    {
                        sumret = double.Parse(retu.Sum().ToString());
                    }
                     %>
              <h3><% Response.Write(sumret); %></h3>

              <p>اجمالي  مرتجعات </p>
            </div>
            <div class="icon">
              <i class="fa fa-dollar"></i>
            </div>
            <span  class="small-box-footer"><%=retu.Count() %> <i class="fa fa-arrow-circle-left"></i></span>
           
            </div>
            </div>
        <br />

          <div class="col-md-12 col-xs-6"></div>
        <div class="col-md-3 col-xs-6">
          <!-- small box -->
          <div class="small-box bg-info text-green">
            <div class="inner">
                <% var vardaan = (from f in db.savee where f.date >= today && f.date<todayplus select f.daan).Sum();
                    var varmdeen = (from f in db.savee where f.date >= today && f.date<todayplus select f.mdeen).Sum();
                   
                    if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["date1"])) && !String.IsNullOrEmpty(Convert.ToString(Request.QueryString["date2"])))
                    {
                        DateTime d1 = Convert.ToDateTime(Request.QueryString["date1"]);
                        DateTime d2 = Convert.ToDateTime(Request.QueryString["date2"]);
                       vardaan = (from f in db.savee where f.date >= d1 && f.date<d2 select f.daan).Sum();
                       varmdeen = (from f in db.savee where f.date >= d1 && f.date<d2 select f.mdeen).Sum();
                   

                    }
                    double income_sum = 0;
                    if (vardaan != null&&varmdeen!=null)
                    {
                        income_sum = double.Parse(vardaan.ToString())-double.Parse(varmdeen.ToString());
                    }
                         %>
              <h3><% Response.Write(income_sum); %></h3>

              <p>ايرادات اليوم</p>
            </div>
            <div class="icon">
              
                <% if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["date1"])) && !String.IsNullOrEmpty(Convert.ToString(Request.QueryString["date2"])))
                   { 
                   string a = Convert.ToString(Request.QueryString["date1"]);
                   string b = Convert.ToString(Request.QueryString["date2"]);

                   %>
             <a  href="incomeHistory.aspx?date1=<%=a %>&&date2=<%=b %>"> <i class=" ion ion-cash  text-green"></i></a>
                <%}
                    else
                    {
                        string a = today.ToShortDateString();
                        string b = todayplus.ToShortDateString();

                        %>
             <a href="incomeHistory.aspx?date1=<%=a %>&&date2=<%=b %>"> <i class=" ion ion-cash  text-green"></i></a>
               
                <%} %>
            </div>
            
          </div>
            </div>



        

          <div class="col-md-3 col-xs-6">
        <div class="small-box bg-danger text-red">
            <div class="inner">
                <% var payments = (from r in db.payment where r.date >= today&& r.date<todayplus &&r.type=="اساسيه" select r.value).Sum();
                    if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["date1"])) && !String.IsNullOrEmpty(Convert.ToString(Request.QueryString["date2"])))
                    {
                        DateTime d1 = Convert.ToDateTime(Request.QueryString["date1"]);
                        DateTime d2 = Convert.ToDateTime(Request.QueryString["date2"]);
                  payments = (from r in db.payment where r.date >= d1&& r.date<d2 &&r.type=="اساسيه" select r.value).Sum();

                    }
                    double pay = 0;
                    if (payments != null)
                    {
                        pay = double.Parse(payments.ToString());
                    }
                     %>
              <h3><% Response.Write(pay); %></h3>

              <p>مصروفات اساسيه</p>
            </div>
            <div class="icon">
              <% if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["date1"])) && !String.IsNullOrEmpty(Convert.ToString(Request.QueryString["date2"])))
                   { 
                   string a = Convert.ToString(Request.QueryString["date1"]);
                   string b = Convert.ToString(Request.QueryString["date2"]);

                   %>
             <a href="paymentHistory.aspx?date1=<%=a %>&&date2=<%=b %>"> <i class="ion ion-card text-red"></i></a>
                <%}
                    else
                    {
                        string a = today.ToShortDateString();
                        string b = todayplus.ToShortDateString();

                        %>
             <a href="paymentHistory.aspx?date1=<%=a %>&&date2=<%=b %>"> <i class="ion ion-card text-red"></i></a>
               
                <%} %>
            </div>
           
            </div>
            </div>


           <div class="col-md-3 col-xs-6">
        <div class="small-box bg-danger text-red">
            <div class="inner">
                <% var payments2 = (from r in db.payment where r.date >= today&& r.date<todayplus &&r.type=="نثريه" select r.value).Sum();
                    if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["date1"])) && !String.IsNullOrEmpty(Convert.ToString(Request.QueryString["date2"])))
                    {
                        DateTime d1 = Convert.ToDateTime(Request.QueryString["date1"]);
                        DateTime d2 = Convert.ToDateTime(Request.QueryString["date2"]);
                  payments2 = (from r in db.payment where r.date >= d1&& r.date<d2 &&r.type=="نثريه" select r.value).Sum();

                    }
                    double pay2 = 0;
                    if (payments2 != null)
                    {
                        pay2 = double.Parse(payments2.ToString());
                    }
                     %>
              <h3><% Response.Write(pay2); %></h3>

              <p>مصروفات نثريه</p>
            </div>
            <div class="icon">
               <% if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["date1"])) && !String.IsNullOrEmpty(Convert.ToString(Request.QueryString["date2"])))
                   { 
                   string a = Convert.ToString(Request.QueryString["date1"]);
                   string b = Convert.ToString(Request.QueryString["date2"]);

                   %>
             <a href="paymentHistory.aspx?date1=<%=a %>&&date2=<%=b %>"> <i class="ion ion-card text-red"></i></a>
                <%}
                    else
                    {
                        string a = today.ToShortDateString();
                        string b = todayplus.ToShortDateString();

                        %>
             <a href="paymentHistory.aspx?date1=<%=a %>&&date2=<%=b %>"> <i class="ion ion-card text-red"></i></a>
               
                <%} %>
            </div>
           
            </div>
            </div>



        



        <% double XT=0,XY=0; 
            %>
          <div class="col-md-3 col-xs-6">
          <!-- small box -->
          <div class="small-box bg-warning text-yellow">
            <div class="inner">
                
              <h3><% Response.Write(income_sum-pay-pay2); %></h3>

              <p> صافي الدرج</p>
            </div>
            <div class="icon">
             
                 <% if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["date1"])) && !String.IsNullOrEmpty(Convert.ToString(Request.QueryString["date2"])))
                   { 
                   string a = Convert.ToString(Request.QueryString["date1"]);
                   string b = Convert.ToString(Request.QueryString["date2"]);

                   %>
              <i class=" fa fa-dollar  text-orange"></i>
                <%}
                    else
                    {
                        string a = today.ToShortDateString();
                        string b = todayplus.ToShortDateString();

                        %>
             <i class=" fa fa-dollar  text-orange"></i>
               
                <%} %>

            </div>
            
          </div>
            </div>




         <div class="col-md-3 col-xs-6">
          <!-- small box -->
          <div class="small-box bg-teal text-gray">
                  <% if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["date1"])) && !String.IsNullOrEmpty(Convert.ToString(Request.QueryString["date2"])))
                      {
                          DateTime d1 = Convert.ToDateTime(Request.QueryString["date1"]);
                          DateTime d2 = Convert.ToDateTime(Request.QueryString["date2"]);
                          string a = Convert.ToString(Request.QueryString["date1"]);
                          string b = Convert.ToString(Request.QueryString["date2"]);
                          var   xx = (from s in db.invoice_items
                                      join ss in db.invoice on s.inv_id equals ss.id

                                      where ss.date>=d1 && ss.date<d2  group s by new { s.prod_name,s.prod_code } into g select new {c=g.Key.prod_code, n = g.Key.prod_name, qty = g.Sum(r => r.quantity) ,summ=g.Sum(r=>r.NetTotal)}).ToList();
                          double total = 0;
                          foreach (var item in xx)

                          {
                              string code = item.c.ToString();
                              double p = double.Parse(item.summ.ToString());
                              double q = double.Parse(item.qty.ToString());

                              var sst = (from st in db.stock where st.code == code select st).FirstOrDefault();
                              double bp = double.Parse(sst.buy_price.ToString());
                              double total_buy = bp * q;
                              total += double.Parse(item.summ.ToString()) - total_buy;
                          }
                          XT = total;
                   %>
             
            <div class="inner">
                
              
                <h3><%=total %></h3>
              <p>ربح الاصناف</p>
            </div>
            <div class="icon">
             
             <a href="profitSearch.aspx?date1=<%=a %>&&date2=<%=b %>">  <i class=" fa fa-dollar  text-gray"></i></a>
              </div>
                  <%}
                    else
                    {
                        string a = today.ToShortDateString();
                        string b = todayplus.ToShortDateString();

                        var    xx = (from s in db.invoice_items
                                 join ss in db.invoice on s.inv_id equals ss.id

                                 where ss.date>=today && ss.date<todayplus  group s by new { s.prod_name,s.prod_code } into g select new {c=g.Key.prod_code, n = g.Key.prod_name, qty = g.Sum(r => r.quantity) ,summ=g.Sum(r=>r.NetTotal)}).ToList();
                         double total = 0;
                         foreach (var item in xx)

                         {
                             int id = int.Parse(item.c);
                             double p = double.Parse(item.summ.ToString());
                             double q = double.Parse(item.qty.ToString());

                             var sst = (from st in db.stock where st.id == id select st).FirstOrDefault();
                             double bp = double.Parse(sst.buy_price.ToString());
                             double total_buy = bp * q;
                             total += double.Parse(item.summ.ToString()) - total_buy;
                         }
                          XT = total;

                        %>
               <div class="inner">
                
              
                <h3><%=total %></h3>
              <p>ربح الاصناف</p>
            </div>
            <div class="icon">
             
             <a href="profitSearch.aspx?date1=<%=a %>&&date2=<%=b %>">  <i class=" fa fa-dollar  text-gray"></i></a>
              </div>
                <%} %>

            
            
          </div>
            </div>

         <div class="col-md-3 col-xs-6">
          <!-- small box -->
          <div class="small-box bg-danger text-red">
                  <% if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["date1"])) && !String.IsNullOrEmpty(Convert.ToString(Request.QueryString["date2"])))
                      {
                          DateTime d1 = Convert.ToDateTime(Request.QueryString["date1"]);
                          DateTime d2 = Convert.ToDateTime(Request.QueryString["date2"]);
                          string a = Convert.ToString(Request.QueryString["date1"]);
                          string b = Convert.ToString(Request.QueryString["date2"]);
                          var   xx = (from s in db.return_items
                                      join ss in db.returninv on s.return_id equals ss.id

                                      where ss.date>=d1 && ss.date<d2  group s by new { s.prod_name,s.prod_code } into g select new {c=g.Key.prod_code, n = g.Key.prod_name, qty = g.Sum(r => r.quantity) ,summ=g.Sum(r=>r.total)}).ToList();
                          double total = 0;
                          foreach (var item in xx)

                          {
                              string code = item.c.ToString();
                              double p = double.Parse(item.summ.ToString());
                              double q = double.Parse(item.qty.ToString());

                              var sst = (from st in db.stock where st.code == code select st).FirstOrDefault();
                              double bp = double.Parse(sst.buy_price.ToString());
                              double total_buy = bp * q;
                              total += double.Parse(item.summ.ToString()) - total_buy;
                          }
                          XY = total;
                   %>
             
            <div class="inner">
                
              
                <h3><%=total %></h3>
              <p> تكلفة المرتجع</p>
            </div>
            <div class="icon">
             
              <i class=" fa fa-dollar  text-red"></i>
              </div>
                  <%}
                    else
                    {
                        string a = today.ToShortDateString();
                        string b = todayplus.ToShortDateString();

                        var    xx = (from s in db.return_items
                                 join ss in db.returninv on s.return_id equals ss.id

                                 where ss.date>=today && ss.date<todayplus  group s by new { s.prod_name,s.prod_code } into g select new {c=g.Key.prod_code, n = g.Key.prod_name, qty = g.Sum(r => r.quantity) ,summ=g.Sum(r=>r.total)}).ToList();
                         double total = 0;
                         foreach (var item in xx)

                         {
                             int code = int.Parse(item.c.ToString());
                             double p = double.Parse(item.summ.ToString());
                             double q = double.Parse(item.qty.ToString());

                             var sst = (from st in db.stock where st.id == code select st).FirstOrDefault();
                             double bp = double.Parse(sst.buy_price.ToString());
                             double total_buy = bp * q;
                             total += double.Parse(item.summ.ToString()) - total_buy;
                         }
                          XY = total;

                        %>
               <div class="inner">
                
              
                <h3><%=total %></h3>
              <p>تكلفة المرتجع</p>
            </div>
            <div class="icon">
             
              <i class=" fa fa-dollar  text-red"></i>
              </div>
                <%} %>

            
            
          </div>
            </div>
          <div class="col-md-3 col-xs-6">
          <!-- small box -->
          <div class="small-box bg-info text-fuchsia">
            <div class="inner">
                
              <h3><% Response.Write(XT-XY-pay2); %></h3>

              <p> صافي الربح</p>
            </div>
            <div class="icon">
             
                 
                      
             <i class=" fa fa-dollar  text-fuchsia"></i>
               
              

            </div>
            
          </div>
            </div>


    </div>
    <div class="col-md-12 box-body bg-gray">
     
    
                
                <div class="col-md-4">
                <label for="middle-name" class="control-label no-print">من :</label>
                    <asp:TextBox ID="fromm" TextMode="Date" CssClass="form-control" runat="server"></asp:TextBox>
           
            </div>
                    <div class="col-md-4">
                <label for="middle-name" class="control-label no-print">الي :</label>
                    <asp:TextBox ID="too" TextMode="Date" CssClass="form-control" runat="server"></asp:TextBox>
           
            </div>
                   <div class="col-md-12"></div>
            
           <div class="col-md-3">
        <br />
        <asp:Button ID="btn4" OnClick="btn4_Click" CssClass="btn btn-primary"  runat="server" Text="بحث " />
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


