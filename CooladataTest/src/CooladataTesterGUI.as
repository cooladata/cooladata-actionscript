package
{
	import com.cooladata.tracking.sdk.flash.CoolaDataTracker;
	import com.cooladata.tracking.sdk.flash.events.OperationCompleteEvent;
	
	import flash.utils.Dictionary;
	
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.controls.LayoutGroup;
	import feathers.controls.ScrollContainer;
	import feathers.controls.TextArea;
	import feathers.controls.TextInput;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalLayout;
	
	import model.TesterConfiguration;
	
	import starling.display.Sprite;
	import starling.events.Event;

	public class CooladataTesterGUI extends Sprite
	{
		private var testerConfiguration:TesterConfiguration; 
		
		private var hostAddressTextInput:TextInput;
		private var apiKeyTextInput:TextInput;
		private var sessionIdTextInput:TextInput;
		private var userIdTextInput:TextInput;
		private var maxQSizeTextInput:TextInput;
		private var maxEventsPerRequestTextInput:TextInput;
		private var eventNameTextInput:TextInput;
		private var setupButton:Button;
		private var logsTextArea:TextArea;
		private var setUpContainer:LayoutGroup;
		private var sendEventContainer:LayoutGroup;
		private var eventParametersContainer:ScrollContainer;
		
		public function CooladataTesterGUI()
		{
			testerConfiguration = new TesterConfiguration
			var theme:CustomMetalWorksTheme = new CustomMetalWorksTheme();
			
			this.addEventListener( Event.ADDED_TO_STAGE, addedToStageHandler );
			
			// Register to all operation events (for debug purpose) 
			CoolaDataTracker.getInstance().addEventListener(OperationCompleteEvent.EVENT__ITEM_IN_QUEUE, onOperationCompleteEvent);
			CoolaDataTracker.getInstance().addEventListener(OperationCompleteEvent.EVENT__TRYING_TO_SEND_EVENTS, onOperationCompleteEvent);
			CoolaDataTracker.getInstance().addEventListener(OperationCompleteEvent.EVENT__EVENTS_SENT_ERROR, onOperationCompleteEvent);
			CoolaDataTracker.getInstance().addEventListener(OperationCompleteEvent.EVENT__EVENTS_SENT_SUCCESS, onOperationCompleteEvent);
			CoolaDataTracker.getInstance().addEventListener(OperationCompleteEvent.EVENT__SECUTIRY_ERROR, onOperationCompleteEvent);
		}
		
		protected function addedToStageHandler( event:Event ):void
		{
			stage.removeEventListener( Event.ADDED_TO_STAGE, addedToStageHandler );
			
			// Try to load the configuration from shared object
			testerConfiguration.loadConfiguration();
	
			var topMostHorizontalLayout:HorizontalLayout = new HorizontalLayout();
			topMostHorizontalLayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_MIDDLE;
			topMostHorizontalLayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
			
			var topMostContainer:LayoutGroup = new LayoutGroup();
			topMostContainer.width = 1024;
			topMostContainer.height = 800;
			topMostContainer.layout = topMostHorizontalLayout;
			this.addChild(topMostContainer);
			
			var verticalLayout:VerticalLayout = new VerticalLayout();
			verticalLayout.gap = 10;

			var generalContainer:LayoutGroup = new LayoutGroup();
			generalContainer.layout = verticalLayout;
			topMostContainer.addChild(generalContainer);
			
			var horizontalLayout:HorizontalLayout = new HorizontalLayout();
			horizontalLayout.gap = 10;
			horizontalLayout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
			
			/*
			*	Header
			*/
			
			var headerLabel:Label = new Label();
			headerLabel.text = "Cooladata Flash Tester";
			headerLabel.styleNameList.add( "header-label" );
			generalContainer.addChild(headerLabel);
			
			setUpContainer = new LayoutGroup();
			setUpContainer.layout = verticalLayout;
			generalContainer.addChild(setUpContainer);
			
			/*
			*	Host address
			*/
	
			var hostNameContainer:LayoutGroup = new LayoutGroup();
			hostNameContainer.layout = horizontalLayout;
			
			setUpContainer.addChild(hostNameContainer);
			
			var hostAddressLabel:Label = new Label();
			hostAddressLabel.width = 150;
			hostAddressLabel.text = "Host Address: ";
			hostNameContainer.addChild(hostAddressLabel);

			hostAddressTextInput = new TextInput();
			hostAddressTextInput.width = 250;
			hostAddressTextInput.text = testerConfiguration.hostAddress;
			hostNameContainer.addChild( hostAddressTextInput );
			
			/*
			*	API key
			*/
			
			var apiKeyContainer:LayoutGroup = new LayoutGroup();
			apiKeyContainer.layout = horizontalLayout;
			
			setUpContainer.addChild(apiKeyContainer);
			
			var apiKeyLabel:Label = new Label();
			apiKeyLabel.width = 150;
			apiKeyLabel.text = "API key: ";
			apiKeyContainer.addChild(apiKeyLabel);
			
			apiKeyTextInput = new TextInput();
			apiKeyTextInput.width = 250;
			apiKeyTextInput.text = testerConfiguration.apiKey;
			apiKeyContainer.addChild( apiKeyTextInput );
			
			/*
			*	Session id
			*/
			
			var SessionKeyContainer:LayoutGroup = new LayoutGroup();
			SessionKeyContainer.layout = horizontalLayout;
			
			setUpContainer.addChild(SessionKeyContainer);
			
			var sessionKeyLabel:Label = new Label();
			sessionKeyLabel.width = 150;
			sessionKeyLabel.text = "Session Id: ";
			SessionKeyContainer.addChild(sessionKeyLabel);
			
			sessionIdTextInput = new TextInput();
			sessionIdTextInput.width = 250;
			sessionIdTextInput.text = testerConfiguration.sessionId;
			SessionKeyContainer.addChild( sessionIdTextInput );
			
			/*
			*	user id
			*/
			
			var userKeyContainer:LayoutGroup = new LayoutGroup();
			userKeyContainer.layout = horizontalLayout;
			
			setUpContainer.addChild(userKeyContainer);
			
			var userIdLabel:Label = new Label();
			userIdLabel.width = 150;
			userIdLabel.text = "User Id: ";
			userKeyContainer.addChild(userIdLabel);
			
			userIdTextInput = new TextInput();
			userIdTextInput.width = 250;
			userIdTextInput.text = testerConfiguration.userId;
			userKeyContainer.addChild( userIdTextInput );
			
			/*
			*	max queue size
			*/
			
			var maxQSizeContainer:LayoutGroup = new LayoutGroup();
			maxQSizeContainer.layout = horizontalLayout;
			
			setUpContainer.addChild(maxQSizeContainer);
			
			var maxQSizeLabel:Label = new Label();
			maxQSizeLabel.width = 150;
			maxQSizeLabel.text = "Max queue size: ";
			maxQSizeContainer.addChild(maxQSizeLabel);
			
			maxQSizeTextInput = new TextInput();
			maxQSizeTextInput.restrict = "0-9";
			maxQSizeTextInput.width = 250;
			maxQSizeTextInput.text = testerConfiguration.maxQSize.toString();
			maxQSizeContainer.addChild( maxQSizeTextInput );
			
			/*
			*	max events per request
			*/
			
			var maxEventsPerRequestContainer:LayoutGroup = new LayoutGroup();
			maxEventsPerRequestContainer.layout = horizontalLayout;
			
			setUpContainer.addChild(maxEventsPerRequestContainer);
			
			var maxQEventsPerRequestLabel:Label = new Label();
			maxQEventsPerRequestLabel.width = 150;
			maxQSizeTextInput.restrict = "0-9";
			maxQEventsPerRequestLabel.text = "Max events per request: ";
			maxEventsPerRequestContainer.addChild(maxQEventsPerRequestLabel);
			
			maxEventsPerRequestTextInput = new TextInput();
			maxEventsPerRequestTextInput.width = 250;
			maxEventsPerRequestTextInput.text = testerConfiguration.maxEventsPerRequest.toString();
			maxEventsPerRequestContainer.addChild( maxEventsPerRequestTextInput );
			
			/*
			*	update
			*/
			
			setupButton = new Button();
			setupButton.label = "Setup";
			setupButton.addEventListener(Event.TRIGGERED, onSetupClicked);
			setUpContainer.addChild( setupButton );
			
			/*
			*	event name
			*/
			
			var sendEventContainerVerticalLayout:VerticalLayout = new VerticalLayout();
			sendEventContainerVerticalLayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_TOP;
			sendEventContainerVerticalLayout.gap = 10;
			
			sendEventContainer = new LayoutGroup();
			sendEventContainer.layout = sendEventContainerVerticalLayout;
			sendEventContainer.isEnabled = false;
			sendEventContainer.alpha = 0.5;
			
			generalContainer.addChild(sendEventContainer);
			
			var eventNameContainer:LayoutGroup = new LayoutGroup();
			horizontalLayout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_TOP;
			eventNameContainer.layout = horizontalLayout;
			
			sendEventContainer.addChild(eventNameContainer);
			
			var eventNameLabel:Label = new Label();
			eventNameLabel.width = 150;
			eventNameLabel.text = "Event name: ";
			eventNameContainer.addChild(eventNameLabel);
			
			eventNameTextInput = new TextInput();
			eventNameTextInput.width = 250;
			eventNameTextInput.text = testerConfiguration.eventName;
			eventNameContainer.addChild( eventNameTextInput );
			
			var addEventParamButton:Button = new Button();
			addEventParamButton.label = "Add Parameter";
			addEventParamButton.addEventListener(Event.TRIGGERED, onAddEventParameter);
			eventNameContainer.addChild(addEventParamButton);
			
			eventParametersContainer = new ScrollContainer();
			eventParametersContainer.height = 150;
			eventParametersContainer.layout = verticalLayout;
			eventNameContainer.addChild(eventParametersContainer);
			
			var sendEventButton:Button = new Button();
			sendEventButton.label = "Send Event";
			sendEventButton.addEventListener(Event.TRIGGERED, onSendEvent);
			sendEventContainer.addChild( sendEventButton );
			
			/*
			*	Logs
			*/
			
			var logsLabel:Label = new Label();
			logsLabel.width = 150;
			logsLabel.text = "Logs: ";
			generalContainer.addChild(logsLabel);
			
			logsTextArea = new TextArea();
			logsTextArea.width = 800;
			logsTextArea.isEditable = false;
			generalContainer.addChild(logsTextArea);
			
			var clearLogsButton:Button = new Button();
			clearLogsButton.label = "Clear Logs";
			clearLogsButton.addEventListener(Event.TRIGGERED, onClearLogs);
			generalContainer.addChild( clearLogsButton );
		}
		
		private function onAddEventParameter(event:Event):void {
			
			var paramsHorizontalLayout:HorizontalLayout = new HorizontalLayout();
			paramsHorizontalLayout.gap = 10;
			
			var paramsContainer:LayoutGroup = new LayoutGroup();
			paramsContainer.layout = paramsHorizontalLayout;
				
			var paramNameTextInput:TextInput = new TextInput();
			paramNameTextInput.width = 100;
			paramNameTextInput.prompt = "Name";
			paramsContainer.addChild( paramNameTextInput );
			
			var paramValueTextInput:TextInput = new TextInput();
			paramValueTextInput.width = 100;
			paramValueTextInput.prompt = "Value";
			paramsContainer.addChild( paramValueTextInput );
			
			var deleteParamButton:Button = new Button();
			deleteParamButton.label = "X";
			deleteParamButton.addEventListener(Event.TRIGGERED, onDeleteParam);
			paramsContainer.addChild(deleteParamButton);
		
			eventParametersContainer.addChild(paramsContainer);
		}
		
		private function onDeleteParam(event:Event):void {
			var deleteParamButton:Button = event.target as Button;
			
			// Get the parent group
			var paramsContainer:LayoutGroup = deleteParamButton.parent as LayoutGroup;
			
			// Remove from the parent parent group
			paramsContainer.parent.removeChild(paramsContainer);
		}
		
		private function onSetupClicked(event:Event):void {
			// Update all fields
			testerConfiguration.hostAddress = hostAddressTextInput.text;
			testerConfiguration.apiKey = apiKeyTextInput.text;
			testerConfiguration.sessionId = sessionIdTextInput.text;
			testerConfiguration.userId = userIdTextInput.text;
			testerConfiguration.maxQSize = parseInt(maxQSizeTextInput.text);
			testerConfiguration.maxEventsPerRequest = parseInt(maxEventsPerRequestTextInput.text);
			testerConfiguration.eventName = eventNameTextInput.text;
			
			CoolaDataTracker.getInstance().getConfigManager().setQueueMaxSize(parseInt(maxQSizeTextInput.text));
			CoolaDataTracker.getInstance().getConfigManager().setMaxEventsPerRequest(parseInt(maxEventsPerRequestTextInput.text));
			CoolaDataTracker.getInstance().setup(apiKeyTextInput.text, hostAddressTextInput.text, userIdTextInput.text, sessionIdTextInput.text);
			
			// Save all to shared object
			testerConfiguration.saveConfiguration();
			
			setUpContainer.isEnabled = false;
			setUpContainer.alpha = 0.5;
			
			sendEventContainer.isEnabled = true;
			sendEventContainer.alpha = 1;
		}
	
		private function onOperationCompleteEvent(event:OperationCompleteEvent):void {
			
			var textToAdd:String = (new Date()).toTimeString() + ": ";
			
			switch (event.type) {
				case OperationCompleteEvent.EVENT__ITEM_IN_QUEUE:
					textToAdd += "Item added to queue. Queue size: " + event.value + "\n";
					break;
				
				case OperationCompleteEvent.EVENT__TRYING_TO_SEND_EVENTS:
					textToAdd += "Trying to send " + event.value + " events\n";	
					break;
				
				case OperationCompleteEvent.EVENT__EVENTS_SENT_ERROR:
					textToAdd += "Error sending events. Queue size: " + event.value + "\n";	
					break;
				
				case OperationCompleteEvent.EVENT__EVENTS_SENT_SUCCESS:
					textToAdd += "Events sent succeesfully. Queue size: " + event.value + "\n";	
					break;
				
				case OperationCompleteEvent.EVENT__SECUTIRY_ERROR:
					textToAdd += "Security error, do you have a crossdomain.xml access?" + "\n";	
					break;
			}
			
			logsTextArea.text = textToAdd + logsTextArea.text;
		}
		
		private function onSendEvent(event:Event):void {
			
			var paramsDictionary:Dictionary = new Dictionary();
			
			if (eventParametersContainer.numChildren > 0) {
				// There are event parameters to send
				
				for (var childrenIndex:int = 0; childrenIndex < eventParametersContainer.numChildren; childrenIndex++) {
					var paramsContainer:LayoutGroup = eventParametersContainer.getChildAt(childrenIndex) as LayoutGroup;
					
					// get the param name 
					var paramNameTextInput:TextInput = paramsContainer.getChildAt(0) as TextInput;

					// ge the param value
					var paramValueTextInput:TextInput = paramsContainer.getChildAt(1) as TextInput;
					
					paramsDictionary[paramNameTextInput.text] = paramValueTextInput.text;
				}
			}
			
			CoolaDataTracker.getInstance().trackEvent(eventNameTextInput.text, null, null, paramsDictionary, null, null);
			
			// Save all to shared object
			testerConfiguration.saveConfiguration();
		}
		
		private function onClearLogs(event:Event):void {
			logsTextArea.text = "";
		}
		
		
	}
}