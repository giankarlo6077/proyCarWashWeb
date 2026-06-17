Imports System.Web
Imports System.Web.UI
Imports System.Web.UI.WebControls
Imports System.Web.UI.HtmlControls

Partial Class Site_master
    Inherits System.Web.UI.MasterPage

    ''' <summary>
    ''' Clave de la opción activa del menú aside. Cada página la define en su Page_Load.
    ''' Valores: inicio, mantenimiento, gestionar, marca, tipo, papelera
    ''' </summary>
    Public Property OpcionActiva As String = ""

    Protected Sub Page_PreRender(sender As Object, e As EventArgs) Handles Me.PreRender
        MarcarActivo()
    End Sub

    Private Sub MarcarActivo()
        Dim mapa As New Dictionary(Of String, HtmlAnchor) From {
            {"inicio", navInicio},
            {"mantenimiento", navMantenimiento},
            {"gestionar", navGestionar},
            {"marca", navMarca},
            {"tipo", navTipo},
            {"papelera", navPapelera}
        }
        For Each par In mapa
            If par.Value IsNot Nothing AndAlso par.Key = OpcionActiva Then
                par.Value.Attributes("class") = "active"
            End If
        Next
    End Sub

End Class
