using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace pdf_viewer
{
    public partial class Form1 : Form
    {
        private string path = "filePath.txt";
        private string filePath = "";
        public Form1()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            timer1.Enabled = true;
            timer1.Start();
        }

        private void timer1_Tick(object sender, EventArgs e)
        {
            progressBar1.Value = 80;
            this.Text = "Dosya Yükleniyor, Lütfen Bekleyin...";
            backgroundWorker1.RunWorkerAsync();
            timer1.Enabled = false;
            timer1.Stop();
            timer1.Dispose();
        }

        private void backgroundWorker1_DoWork(object sender, DoWorkEventArgs e)
        {
            using (StreamReader reader = new StreamReader(path))
            {
                string content = reader.ReadToEnd();
                filePath = content;
            }
        }

        private void backgroundWorker1_RunWorkerCompleted(object sender, RunWorkerCompletedEventArgs e)
        {
            officeViewer1.LoadFromFile(filePath);
            this.Text = "Dosya Önizleme Yapılıyor...";
            progressBar1.Value = 100;
            progressBar1.Visible = false;
            pictureBox1.Visible = false;
        }
    }
}
