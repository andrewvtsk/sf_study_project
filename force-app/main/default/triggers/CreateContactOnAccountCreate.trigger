trigger CreateContactOnAccountCreate on Account (before insert) {
    List<Contact> contactList = new List<Contact>();

    for (Account acc : Trigger.new) {
        Contact newContact = new Contact();
        newContact.FirstName = acc.Name; // Use Account Name as Contact First Name
        newContact.LastName = 'Contact'; // You can set the Last Name as needed
        newContact.Email = 'contact@sample.com'; // You can set the email as needed
        newContact.AccountId = acc.Id; // Link the Contact to the Account
        contactList.add(newContact);
    }

    insert contactList;
}