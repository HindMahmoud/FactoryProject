<%@ Page Title="" Language="C#"  AutoEventWireup="true" CodeFile="Indexpage.aspx.cs" Inherits="Indexpage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style type="text/css">
        .auto-style1 {
            background: #00a65a !important;
            background: -webkit-gradient(linear, left bottom, left top, color-stop(0, #00a65a), color-stop(1, #00ca6d)) !important;
            background: -ms-linear-gradient(bottom, #00a65a, #00ca6d) !important;
            background: -moz-linear-gradient(center bottom, #00a65a 0, #00ca6d 100%) !important;
            background: #00a65a;
            filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#00ca6d', endColorstr='#00a65a', GradientType=0) !important;
            color: #fff;
            margin-top: 0;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="row">
        <% FactoryDBEntities db = new FactoryDBEntities();
            DateTime today = DateTime.Now.Date;
            DateTime plus = today.AddDays(1);

             %>

        <div class="col-md-4 col-xs-6">
        <div class="small-box bg-red">
            <div class="inner">
                <% var payments = (from r in db.payment where r.date >= today && r.date<plus select r.value).Sum();
                    double pay = 0;
                    if (payments != null)
                    {
                        pay = double.Parse(payments.ToString());
                    }
                     %>
              <h3><% Response.Write(pay); %></h3>

              <p>مصروفات اليوم</p>
            </div>
            <div class="icon">
              <i class="ion ion-pie-graph"></i>
            </div>
           
            </div>
            </div>
       
 <%if (Session["role"] != null)
        {
            if (Session["role"].ToString() == "All permission")
            {


             %>

        <div class="col-md-4 col-xs-6">
          <!-- small box -->
          <div class="small-box bg-green">
            <div class="inner">
                <% var mdeensave = (from f in db.savee where f.date >= today && f.date<plus &&f.roleType==roleType select f.mdeen).Sum();
                    var daansave = (from f in db.savee where f.date >= today && f.date<plus &&f.roleType==roleType select f.daan).Sum();
                    var incomesbank = (from f in db.bank_account where f.datep >= today && f.datep<plus &&f.typeRole==roleType select f.mdeen).Sum();
                    var incomes = (from f in db.bank_account where f.datep >= today && f.datep<plus &&f.typeRole==roleType select f.daan).Sum();
                    double income_sum = 0;
                    double incom_sumSavee = 0;
                    if (incomes != null&&incomesbank!=null)
                    {
                        income_sum = double.Parse((incomes - incomesbank).ToString());
                    }
                    if (mdeensave != null&&daansave!=null)
                    {
                        incom_sumSavee = double.Parse((daansave-mdeensave).ToString());
                    } 
                    
                        %>
              <h3><% Response.Write(income_sum+incom_sumSavee); %></h3>
             <p>ايرادات اليوم</p>
            </div>
            <div class="icon">
              <i class=" fa  fa-dollar (alias)"></i>
            </div>
            
          </div>

            </div>
      <% }
         }  %>
         
        
        <div class="col-md-12" >
            <div class="col-md-8" style="overflow-y:auto" >
                <div class="box box-primary">
            <div class="box-header">
              <h3 class="box-title">فواتير اليوم</h3>

              <div class="box-tools">
                <div class="input-group input-group-sm" style="width: 150px;">
                  <input type="text" name="table_search" id="search" class="form-control pull-right" onkeyup="myFunction()" placeholder="Search">

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
                      string user="";
                      if(Session["name"] !=null)
                      {
                          user = Session["name"].ToString();


                      }
                      else { Response.Redirect("login.aspx"); }
                      var x = (from ss in db.invoice join s in db.customer on ss.customer_id equals s.id  where ss.user_name==user && ss.date >= today && ss.date<plus&&ss.typeRole==roleType select new { ss, s }).OrderByDescending(df=>df.ss.id).ToList();

                      if (Session["role"].ToString() != "All permission")
                      {
                           x = (from ss in db.invoice join s in db.customer on ss.customer_id equals s.id  where   ss.date >= today && ss.date<plus&&ss.typeRole==roleType select new { ss, s }).OrderByDescending(df=>df.ss.id).ToList();
                      }
                      DateTime d = DateTime.Now.Date;
                      if (x != null)
                      {

                       %>
                 
                <tr>
                 
                  <th>العميل</th>
                  <th>رقم الفاتورة </th>
                  <th>الاجمالي</th>
                  <th>الاجمالي بعد الخصم</th>
                  <th>سداد</th>
                  <th>اسم المستخدم</th>
                 

                </tr>
                  <% foreach (var item in x)
                      { %>
                  <tr>
                 <td><% Response.Write(item.s.name); %></td>
                 <td><% Response.Write(item.ss.inv_id); %></td>
                 <td><% Response.Write(item.ss.total); %></td>

                 <td><% Response.Write(item.ss.Nettotal); %></td>
                 <td><% Response.Write(item.ss.payed); %></td>
                 <td><% Response.Write(item.ss.user_name); %></td>
               <%-- <td><a  href='Indexpage.aspx?invprint=<%=item.ss.inv_id %>'>  <i class="fa fa-print text-blue"></i></a></td>
                --%>  
                   

                </tr>
                    <%  }
                        }%>
               
              </table>
            </div>
            <!-- /.box-body -->
          </div>
          
            </div>
            <% var most = (from s in db.invoice_items where s.status == 1 && s.quantity > 0 group s by new { s.prod_name } into g select new { n = g.Key.prod_name, sum = g.Sum(a => a.quantity) ,summ=g.Sum(a=>a.total)}).ToList();
                var most5 = most.OrderByDescending(a => a.summ).Take(5);
                 %>
            
            <div class="col-md-4 ">
                 <div class="box box-warning">
            <div class="box-header">
              <h3 class="box-title">الاكثر مبيعا</h3>

              <div class="box-tools">
                <div class="input-group input-group-sm" style="width: 150px;">
                  
                </div>
              </div>
              
            </div>
            <!-- /.box-header -->
                     <br />
            <div class="box-body table-responsive no-padding">
              <table class="table table-hover" id="mytable2">
                 
                 <%
                     if(most5 !=null)
                     { 
                      %>
                <tr>
                 
                  <th>اسم المنتج</th>
                  <th>الكميه </th>
                  <th>الاجمالي </th>


                  
                </tr>
                  <% foreach (var item in most5)
                      { %>
                  <tr>
                 <td><% Response.Write(item.n); %></td>
                 <td><% Response.Write(item.sum); %></td>
                 <td><% Response.Write(item.summ); %></td>


                 

                </tr>
                    <%  }
                        } %>
               
              </table>
            </div>
            </div>

        </div>
         
        </div>
        <div class="col-md-12">
            <div class="col-md-8"></div>
             <% var most1 = (from s in db.invoice_items where s.status == 1 && s.quantity > 0 group s by new { s.prod_name } into g select new { n = g.Key.prod_name, sum = g.Sum(a => a.quantity) ,summ=g.Sum(a=>a.total)}) .Distinct().ToList();
                var most55 = most1.OrderBy(a => a.summ).Take(5);
                 %>
            <div class="col-md-4 ">
                 <div class="box box-danger">
            <div class="box-header">
              <h3 class="box-title">الاقل مبيعا</h3>

              <div class="box-tools">
                <div class="input-group input-group-sm" style="width: 150px;">
                  
                </div>
              </div>
                <%--<asp:TextBox  ID="TextBox1" runat="server"></asp:TextBox><asp:Button CssClass="bg-green-gradient" ID="Button2" OnClick="Button2_Click" runat="server" Text="دفع" />
           --%>
            </div>
            <!-- /.box-header -->
                     <br />
            <div class="box-body table-responsive no-padding">
              <table class="table table-hover" id="mytable22">
                 
                 <%
                     if(most55 !=null)
                     { 
                      %>
                <tr>
                 
                  <th>اسم المنتج</th>
                  <th>الكميه </th>
                  <th>الاجمالي </th>


                  
                </tr>
                  <% foreach (var item in most55)
                      { %>
                  <tr>
                 <td><% Response.Write(item.n); %></td>
                 <td><% Response.Write(item.sum); %></td>
                 <td><% Response.Write(item.summ); %></td>


                 

                </tr>
                    <%  }
                        } %>
               
              </table>
            </div>
            </div>

        </div>
        </div>
</asp:Content>

