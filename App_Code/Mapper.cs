using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for Mapper
/// </summary>
public static class Mapper
{
    
  public static FactoryDBEntities db = new FactoryDBEntities();

    //public static int  addcompany(company com)
    //{
    //    db.company.Add(com);
    //    return db.SaveChanges();
    //}
    //public static int addacc(accessories com)
    //{
    //    db.accessories.Add(com);
    //    return db.SaveChanges();
    //}

    //public static int addserv(services com)
    //{
    //    db.services.Add(com);
    //    return db.SaveChanges();
    //}
    //public static int addpatient_services(patient_services com)
    //{
    //    db.patient_services.Add(com);
    //    return db.SaveChanges();
    //}

    public static int addstock(stock ss)
    {
        db.stock.Add(ss);
        return db.SaveChanges();
    }
    public static int addpayment(payment com)
    {
        db.payment.Add(com);
        return db.SaveChanges();
    }
    public static int addcustomer(customer com)
    {
        db.customer.Add(com);
        return db.SaveChanges();
    }
    public static int addimporter(importer com)
    {
        db.importer.Add(com);
        return db.SaveChanges();
    }
    public static int addIMPORTERaccount(importer_account com)
    {
        db.importer_account.Add(com);
        return db.SaveChanges();
    }
    public static int addreturn(returninv com)
    {
        db.returninv.Add(com);
        return db.SaveChanges();
    }
    public static int addretuenitems(return_items com)
    {
        db.return_items.Add(com);
        return db.SaveChanges();
    }
    public static int addCustomeraccount(customer_account com)
    {
        db.customer_account.Add(com);
        return db.SaveChanges();
    }

    public static int addmed(stock com)
    {
        db.stock.Add(com);
        return db.SaveChanges();
    }
    public static int addimportitems(import_items com)
    {
        db.import_items.Add(com);
        return db.SaveChanges();
    }
    public static int addimport(import com)
    {
        db.import.Add(com);
        return db.SaveChanges();
    }

    public static int addinvoiceitems(invoice_items com)
    {
        db.invoice_items.Add(com);
        return db.SaveChanges();
    }
    public static int addinvoice(invoice com)
    {
        db.invoice.Add(com);
        return db.SaveChanges();
    }
    public static int adduser(users com)
    {
        db.users.Add(com);
        return db.SaveChanges();
    }
   
}