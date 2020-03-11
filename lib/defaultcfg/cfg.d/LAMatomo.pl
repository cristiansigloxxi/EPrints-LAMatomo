=pod

=head1 LA Referencia Matomo Data Provider

Provide data for LA Referencia usage statistics.

Released to the public domain (or CC0 depending on your juristiction).

USE OF THIS EXTENSION IS ENTIRELY AT YOUR OWN RISK

=head2 Implementation

Record to the configured Matomo server whenever an item is viewed or full-text object is requested from EPrints.

=head2 Changes

v1.0

Initial version
- based on "OpenAIRE Piwik tracker for EPrints" <https://github.com/openaire/EPrints-OAPiwik>

=cut

require LWP::UserAgent;
require LWP::ConnCache;

##################
# CONFIG START  #
################

# Modify the following URL to the Matomo tracker location
$c->{LAMatomo}->{tracker} = "http://matomo.lareferencia.info/matomo.php";

# Enter the LA Referencia Matomo Site ID
$c->{LAMatomo}->{siteID} = "47";

# Enter the matomo token_auth
$c->{LAMatomo}->{token_auth} = "4351b5525feb89c92f54b94693b5a8f3";

# Specify the number of bytes, 1,2 or 3, for IP Anonymization (empty for no IP Anonymization)
$c->{LAMatomo}->{noOfBytes} = "";

# Identifier in the Directory of Open Access Repositories (OpenDOAR)
$c->{LAMatomo}->{repositoryID} = "";

# ISO Country Code
$c->{LAMatomo}->{countryID} = "";

# Other Config Parameters
$c->{LAMatomo}->{ua} = LWP::UserAgent->new(conn_cache => LWP::ConnCache->new,);

$c->{plugins}->{"Event::LAMatomo"}->{params}->{disable} = 0;


################
# CONFIG END  #
##############

##############################################################################

$c->add_dataset_trigger( 'access', EPrints::Const::EP_TRIGGER_CREATED, sub {
	my( %args ) = @_;

	my $repo = $args{repository};
	my $access = $args{dataobj};

	my $plugin = $repo->plugin( "Event::LAMatomo" );

	my $r = $plugin->log( $access, $repo->current_url( host => 1 ));
});
