from supabase import create_client, Client
from config import get_config

config = get_config()

class DatabaseService:
    """Service for interacting with Supabase database"""
    
    def __init__(self):
        if not config.SUPABASE_URL or not config.SUPABASE_KEY:
            raise ValueError("Supabase credentials not configured")
        
        self.client: Client = create_client(
            config.SUPABASE_URL,
            config.SUPABASE_KEY
        )
    
    def get_client(self) -> Client:
        """Get Supabase client instance"""
        return self.client
    
    # User operations
    def get_user_by_id(self, user_id: str):
        """Get user by ID (UUID)"""
        response = self.client.table('users').select('*').eq('id', user_id).execute()
        return response.data[0] if response.data else None
    
    def get_user_by_email(self, email: str):
        """Get user by email"""
        response = self.client.table('users').select('*').eq('email', email).execute()
        return response.data[0] if response.data else None
    
    def create_user(self, user_data: dict):
        """Create new user"""
        response = self.client.table('users').insert(user_data).execute()
        return response.data[0] if response.data else None
    
    def update_user(self, user_id: str, user_data: dict):
        """Update user (UUID)"""
        response = self.client.table('users').update(user_data).eq('id', user_id).execute()
        return response.data[0] if response.data else None
    
    # Addiction operations
    def get_user_addictions(self, user_id: str):
        """Get all addictions for a user (UUID)"""
        response = self.client.table('addictions').select('*').eq('user_id', user_id).execute()
        return response.data
    
    def get_addiction(self, addiction_id: int):
        """Get addiction by ID"""
        response = self.client.table('addictions').select('*').eq('id', addiction_id).execute()
        return response.data[0] if response.data else None
    
    def get_addiction_by_id(self, addiction_id: int):
        """Get addiction by ID"""
        response = self.client.table('addictions').select('*').eq('id', addiction_id).execute()
        return response.data[0] if response.data else None
    
    def create_addiction(self, addiction_data: dict):
        """Create new addiction"""
        response = self.client.table('addictions').insert(addiction_data).execute()
        return response.data[0] if response.data else None
    
    def update_addiction(self, addiction_id: int, addiction_data: dict):
        """Update addiction"""
        response = self.client.table('addictions').update(addiction_data).eq('id', addiction_id).execute()
        return response.data[0] if response.data else None
    
    def delete_addiction(self, addiction_id: int):
        """Delete addiction"""
        response = self.client.table('addictions').delete().eq('id', addiction_id).execute()
        return response.data
    
    # Survey operations (check-ins)
    def create_survey(self, survey_data: dict):
        """Create survey (check-in)"""
        response = self.client.table('surveys').insert(survey_data).execute()
        return response.data[0] if response.data else None
    
    def get_surveys_by_addiction(self, addiction_id: int, date: str = None):
        """Get surveys for an addiction, optionally filtered by date"""
        query = self.client.table('surveys').select('*').eq('addiction_id', addiction_id)
        if date:
            query = query.eq('date', date)
        response = query.execute()
        return response.data
    
    # Milestone operations
    def get_milestones(self, addiction_id: int):
        """Get milestones for an addiction"""
        response = self.client.table('milestones').select('*').eq('addiction_id', addiction_id).execute()
        return response.data
    
    def get_milestone(self, milestone_id: int):
        """Get milestone by ID"""
        response = self.client.table('milestones').select('*').eq('id', milestone_id).execute()
        return response.data[0] if response.data else None
    
    def get_milestones_by_addiction(self, addiction_id: int):
        """Get milestones for an addiction"""
        response = self.client.table('milestones').select('*').eq('addiction_id', addiction_id).execute()
        return response.data
    
    def create_milestone(self, milestone_data: dict):
        """Create milestone"""
        response = self.client.table('milestones').insert(milestone_data).execute()
        return response.data[0] if response.data else None
    
    def update_milestone(self, milestone_id: int, milestone_data: dict):
        """Update milestone"""
        response = self.client.table('milestones').update(milestone_data).eq('id', milestone_id).execute()
        return response.data[0] if response.data else None

# Singleton instance
db_service = DatabaseService()
