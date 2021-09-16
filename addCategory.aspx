<%@ Page Title="" Language="C#" MasterPageFile="~/Home.master" AutoEventWireup="true" CodeFile="addCategory.aspx.cs" Inherits="addCategory" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="row ">
        <div class="col-md-3">
            اسم التصنيف <span class="star-validation">*</span>
            <asp:TextBox ID="cat" CssClass="form-control" runat="server"></asp:TextBox>
            <asp:requiredfieldvalidator runat="server" errormessage="برجاء ادخال الاسم" controlToValide="cat"></asp:requiredfieldvalidator>
            </div>
    <div class="col-md-2">
        <br />
        <asp:Button ID="add" OnClick="add_Click" CssClass="btn btn-primary" runat="server" Text="اضافه" />
    </div>
    <div class="col-md-6">

        <div class="row">
        <div class="col-xs-12">
          <div class="box">
            <div class="box-header">
              <h3 class="box-title">التصنيفات</h3>
                
              <div class="box-tools">
                <div class="input-group input-group-sm" style="width: 150px;">
                  <input type="text" name="table_search" id="search" class="form-control pull-right" onkeyup="myFunction1()" placeholder="search..">

                </div>
              </div>
            </div>
            <!-- /.box-header -->
            <div class="box-body table-responsive no-padding">
              <table class="table table-hover" id="mytable">
                  <% 
                      DateTime d = DateTime.Now.Date;
                      var x = (from ss in db.category where ss.roleType==roleType select ss).ToList();
                      if (x != null)
                      {
                       %>
                <tr>
                  
                    <th>#</th>
                  <th>الاسم</th>
                  
                
                  <th></th>
                 
                  <th></th>


                </tr>
                  <% foreach (var item in x)
    {
                           %> 
                      
                <tr>
                     <td><% Response.Write(item.id); %></td>

                 <td><% Response.Write(item.name); %></td>
                
                 
                    
                   <td><a  href='addCategory.aspx?id=<%=item.id %>'>  <i class="fa fa-trash-o text-red"></i></a></td>


                    

                </tr>
                    <%  }
    }%>
               
              </table>
            </div>
            <!-- /.box-body -->
          </div>
          <!-- /.box -->
        </div>
      </div>
    
    </div>
      </div>

</asp:Content>

