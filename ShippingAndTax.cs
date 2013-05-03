using System;
using System.Collections.Generic;
using System.Linq;
using System.Windows.Forms;

namespace ShippingAndTax
{
    static class Program
    {
        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        [STAThread]
        static void Main()
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            Application.Run(new Form1());
        }
    }
}

/*program to calculate shipping and tax (of 7%) based upon
 * total of prices entered by user. The output is calculated
 * at the calculate button click. Also checks to make sure text
 * value can be parsed as a double. If not, give feedback to user.
 */

namespace ShippingAndTax
{
    public partial class Form1 : Form
    {
        internal const double tax = .07;
        public Form1()
        {
            InitializeComponent();
            //set focus to items price field//
            txtPrice.Select();
           
        }
        private void btnCalculate_Click(object sender, EventArgs e)
        {
            double shipping = 0;
            double tempPrice = 0;

            //check to make sure text field has a value//
            if (Double.TryParse(txtPrice.Text, out tempPrice))
            {
                txtPrice.Text = tempPrice.ToString("c");
                //if a number then it is assigned to tempPrice//
            }
            else
            {
                //if cannot be converted, tempPrice remains 0//
                txtPrice.Text = "Please enter a valid number.";
            }
         
            //calculate shipping tier based on price entered// 
            if (tempPrice <= 250 && tempPrice > 0)
            {
                shipping = 5;
            }
            else if (tempPrice >= 250.01 && tempPrice <= 500)
            {
                shipping = 8; 
            }
            else if (tempPrice >= 500.01 && tempPrice <= 1000)
            {
                shipping = 10;
            }
            else if (tempPrice >= 1000.01 && tempPrice <= 5000)
            {
                shipping = 15;
            }
            else if (tempPrice >= 5000.01)
            {
                shipping = 20;
            }

            //if items purchased is 0 clear out shipping charge//
            if (shipping > 0)
            {
                lblShipping.Text = "$" + shipping.ToString();  
            }
            else
            {
                lblShipping.Text = "$0";
            }
            //assign totals, price plus tax plus any applicable shipping costs//
            double totals = tempPrice + (tempPrice * tax) + shipping;
            txtTotal.Text = totals.ToString("C");

        }

        private void btnClose_Click(object sender, EventArgs e)
        {
            Close();
        }
    }
}
