<%@ Page Title="" Language="C#" MasterPageFile="~/Home.master" AutoEventWireup="true" CodeFile="money.aspx.cs" Inherits="money" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <%if (Session["role"] != null)
        {
            if (Session["role"].ToString() == "All permission")
            {


             %>
     <div class="row">

         
         <div class="col-md-4 col-xs-6">
        <div class="small-box bg-aqua-gradient">
            <div class="inner">
                <% FactoryDBEntities db = new FactoryDBEntities();

                   
                    var g = (from ss in db.savee where ss.roleType==roleType   select ss).Distinct().ToList();
                     if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["date1"]))&&!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["date2"])))
                      {
                          DateTime d1 = Convert.ToDateTime(Request.QueryString["date1"]);

                          DateTime d2 = Convert.ToDateTime(Request.QueryString["date2"]);
                        g = (from ss in  db.savee where ss.roleType==roleType  && ss.date>=d1 &&ss.date<d2 select ss).Distinct().ToList();

                      }
                    double max_value = 0;
                    if (g != null)
                    {
                         max_value = double.Parse((g.Sum(a=>a.daan)-g.Sum(a=>a.mdeen)).ToString());

                    }
                     %>
              <h3><% Response.Write(max_value); %></h3>

              <p>رصيد الخزنه</p>
            </div>
            <div class="icon">
              <i class="ion ion-cash"></i>
            </div>
           
            </div>
            </div>


         <div class="col-md-4 col-xs-6">
        <div class="small-box bg-green-gradient">
            <div class="inner">
                <% 

                    var most = (from s in db.bank_account where s.typeRole == roleType group s by new { s.bank_id,s.bank_name } into gf select new { n = gf.Key.bank_id,gf.Key.bank_name, mdenSum = gf.Sum(a => a.mdeen) ,daansum=gf.Sum(a=>a.daan)}).ToList();
                    // int max_id2 = (from s in db.bank select s.id).Max();

                    //var g2 = (from ss in db.bank where ss.roleType==roleType select ss).Distinct().ToList();
                    if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["date1"])) && !String.IsNullOrEmpty(Convert.ToString(Request.QueryString["date2"])))
                    {
                        DateTime d1 = Convert.ToDateTime(Request.QueryString["date1"]);

                        DateTime d2 = Convert.ToDateTime(Request.QueryString["date2"]);
                        most = (from s in db.bank_account where s.typeRole == roleType&&s.datep>=d1&&s.datep<d2 group s by new { s.bank_id,s.bank_name } into gf select new { n = gf.Key.bank_id,gf.Key.bank_name, mdenSum = gf.Sum(a => a.mdeen) ,daansum=gf.Sum(a=>a.daan)}).ToList();

                    }
                    double? max_value2 = 0;
                    if (most != null)
                    { double? totalDan = 0;
                        double? totalmdeen = 0;
                        foreach (var r in most)
                        {
                            totalDan += r.daansum;
                            totalmdeen += r.mdenSum;
                        }
                        max_value2 = (totalDan - totalmdeen);
                    }
                     %>
              <h3><% Response.Write(max_value2); %></h3>

              <p>رصيد البنوك</p>
            </div>
            <div class="icon">
              <i class="fa fa-dollar"></i>
            </div>
           
            </div>
            </div>
        <div class="col-md-12"></div>
        <div class="col-xs-6" style="overflow-x:auto;height:700px">
          <div class="box">
            <div class="box-header">
              <h3 class="box-title">الخزنه</h3>
                
              <div class="box-tools">
                <div class="input-group input-group-sm" style="width: 150px;">
                  
                </div>
              </div>
            </div>
            <!-- /.box-header -->
            <div class="box-body table-responsive no-padding">
              <table class="table table-hover text-center bg-gray" id="mytable">
                  <% 

                      DateTime d = DateTime.Now.Date;
                      var x = (from ss in db.savee where ss.roleType==roleType select ss).OrderByDescending(a=>a.id).Take(50);
                       if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["date1"]))&&!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["date2"])))
                      {
                          DateTime d1 = Convert.ToDateTime(Request.QueryString["date1"]);

                          DateTime d2 = Convert.ToDateTime(Request.QueryString["date2"]);
                          x = (from ss in db.savee  where ss.date>=d1 &&ss.date<d2 &&ss.roleType==roleType select ss).OrderByDescending(a=>a.id);

                      }
                      if (x != null)
                      {
                       %>
                <tr class="bg-info">
                  
                  <th>مدين</th>
                  <th> دائن</th>
                   <th> التاريخ</th>
                   <th>النوع</th>
                </tr>
                  <% foreach (var item in x)
    {
                           %> 
                      
                <tr>
                  
                 <td class="bg-success"><% Response.Write(item.mdeen); %></td>
                 <td class="bg-danger"><% Response.Write(item.daan); %></td>
                 
               
                 <td><% Response.Write(item.date); %></td>
                
                 <td><%if(item.daan!=0&&item.mdeen==0) Response.Write("ايداع"); else Response.Write("سحب");%></td>
                
                    

                </tr>
                    <%  }%>
                  
              <tr class="bg-info text-bold">
                   <%

                       double k11 = 0;
                       if (x.Sum(a => a.daan) != null)
                       {
                           k11 = double.Parse(x.Sum(a => a.daan).ToString());
                       }
                       double k22=0;
                       if (x.Sum(a => a.mdeen) != null)
                       {
                      k22 = double.Parse(x.Sum(a => a.mdeen).ToString());
                       }
                       double k3 = k11 - k22;
                        %>
                   <td><%=k22%></td>
                   <td><%=k11 %></td>
                   <td colspan="2">الرصيد  <%=k3 %></td>


               </tr>
                  <%
    }%>
              </table>
            </div>
            <!-- /.box-body -->
          </div>
          <!-- /.box -->
        </div>
       <div class="col-xs-6" style="overflow-x:auto;height:700px">
          <div class="box">
            <div class="box-header">
              <h3 class="box-title">البنوك</h3>
                
              <div class="box-tools">
                <div class="input-group input-group-sm" style="width: 150px;">
                 
                </div>
              </div>
            </div>
            <!-- /.box-header -->
            <div class="box-body table-responsive no-padding">
              <table class="table table-hover text-center bg-gray-active" >
                  <%
                       var most2 = (from s in db.bank_account where s.typeRole == roleType group s by new { s.bank_id,s.bank_name } into gf select new { n = gf.Key.bank_id,gf.Key.bank_name, mdenSum = gf.Sum(a => a.mdeen) ,daansum=gf.Sum(a=>a.daan)}).ToList();
                   if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["date1"]))&&!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["date2"])))
                      {
                          DateTime d1 = Convert.ToDateTime(Request.QueryString["date1"]);

                          DateTime d2 = Convert.ToDateTime(Request.QueryString["date2"]);
                          most2 = (from s in db.bank_account where s.typeRole == roleType&&s.datep>=d1&&s.datep<d2 group s by new { s.bank_id,s.bank_name } into gf select new { n = gf.Key.bank_id,gf.Key.bank_name, mdenSum = gf.Sum(a => a.mdeen) ,daansum=gf.Sum(a=>a.daan)}).ToList();
                   
                      }
                      if (most2 != null)
                      {
                       %>
                <tr class="bg-info"> 
                  
                  <th>  اجمال المدين</th>
                  <th>  اجمالي الدائن</th>
                  <th>  اسم البنك</th>
                </tr>
                  <% foreach (var item in most2)
    {
                           %> 
                      
                <tr>
                  
                 <td class="bg-success"><% Response.Write(item.mdenSum); %></td>
                 <td class="bg-danger"><% Response.Write(item.daansum); %></td>
                 <td><% Response.Write(item.bank_name); %></td>
                </tr>
                    <%  }
                            %>
                
               <tr class="bg-info text-bold">
                   <%
                       double k1 = 0;
                       if (most2.Sum(a => a.mdenSum) != null)
                       {
                           k1 = double.Parse(most2.Sum(a => a.mdenSum).ToString());
                       }
                       double k2 = 0;
                       if (most2.Sum(a => a.daansum) != null)
                       {
                           k2 = double.Parse(most2.Sum(a => a.daansum).ToString());
                       }
                       double k = k2-k1 ;
                        %>
                   <td><%=k1%></td>
                   <td><%=k2 %></td>
                   <td colspan="2">الرصيد <%=k %></td>


               </tr>
                    <%
    }%>

              </table>
            </div>
            <!-- /.box-body -->
          </div>
          <!-- /.box -->
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

