Partial Class MasterPage
    Inherits System.Web.UI.MasterPage

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            If Session("NombreTrabajador") IsNot Nothing Then
                lblNombreUsuarioNav.Text = Convert.ToString(Session("NombreTrabajador"))
            Else
                lblNombreUsuarioNav.Text = "Invitado"
            End If
        End If
    End Sub

    Protected Sub btnCerrarSesion_Click(ByVal sender As Object, ByVal e As EventArgs)
        Session.Clear()
        Session.Abandon()
        Response.Redirect("jdInicioSesion.aspx")
    End Sub

End Class