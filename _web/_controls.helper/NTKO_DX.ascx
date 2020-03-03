<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="NTKO_DX.ascx.cs" Inherits="eTaxi.Web.Controls.NTKO_DX" %>
<dx:ASPxSplitter runat="server" ID="p" FullscreenMode="true" Orientation="Vertical">
    <Styles>
        <Separator BackColor="#FFFFFF">
            <Border BorderStyle="None" />
        </Separator>
    </Styles>
    <Panes>
        <dx:SplitterPane AllowResize="true" AutoHeight="true" Name="N">
            <PaneStyle>
                <Paddings Padding="0" />
                <Border BorderStyle="None" />
            </PaneStyle>
            <ContentCollection>
                <dx:SplitterContentControl runat="server">
                    <%--ABC--%>
                </dx:SplitterContentControl>
            </ContentCollection>
        </dx:SplitterPane>
        <dx:SplitterPane Name="C">
            <Separator Visible="false"></Separator>
            <Panes>
                <dx:SplitterPane Name="CW" Size="5">
                    <PaneStyle>
                        <Paddings Padding="0" />
                        <Border BorderStyle="None" />
                    </PaneStyle>
                </dx:SplitterPane>
                <dx:SplitterPane Name="CC">
                    <PaneStyle>
                        <Paddings Padding="0" />
                        <Border BorderStyle="Solid" />
                    </PaneStyle>
                </dx:SplitterPane>
            </Panes>
        </dx:SplitterPane>
    </Panes>
</dx:ASPxSplitter>
<script runat="server">

    protected override void _SetInitialStates()
    {
        base._SetInitialStates();
    }
    
</script>
