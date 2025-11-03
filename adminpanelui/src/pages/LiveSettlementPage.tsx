import React, { useState, useEffect, useRef } from 'react';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import { gameService, LiveSettlementData } from '@/services/services';
import { 
  RefreshCw, 
  Trophy, 
  Clock, 
  AlertCircle, 
  PlayCircle, 
  CheckCircle2,
  Timer,
  TrendingUp,
  TrendingDown
} from 'lucide-react';

const LiveSettlementPage: React.FC = () => {
  const [data, setData] = useState<LiveSettlementData | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState('');
  const [selectedCard, setSelectedCard] = useState<number | null>(null);
  const [isSettling, setIsSettling] = useState(false);
  const [settlementCountdown, setSettlementCountdown] = useState<number | null>(null);
  const [showConfirmDialog, setShowConfirmDialog] = useState(false);
  
  // State to keep previous game data during settlement window
  const [displayedGame, setDisplayedGame] = useState<LiveSettlementData['current_game'] | null>(null);
  const [settlementWindowEndTime, setSettlementWindowEndTime] = useState<number | null>(null);
  
  const pollIntervalRef = useRef<NodeJS.Timeout | null>(null);
  const countdownIntervalRef = useRef<NodeJS.Timeout | null>(null);

  // Fetch live settlement data
  const fetchData = async () => {
    try {
      const response = await gameService.getLiveSettlementData();
      setData(response);
      setError('');
      
      const currentGame = response.current_game;
      
      // Priority logic:
      // 1. If we're displaying an un-settled completed game, KEEP showing it (don't switch to new game)
      // 2. If backend returns an un-settled completed game, show it
      // 3. Only show active/pending games if no un-settled games exist
      
      // Check if we're currently displaying an un-settled completed game
      const isDisplayingUnsettled = displayedGame?.status === 'completed' && 
                                     displayedGame?.settlement_status === 'not_settled';
      
      if (isDisplayingUnsettled) {
        // We're already showing an un-settled game - check if backend still has it
        if (currentGame?.game_id === displayedGame.game_id) {
          // Backend still returns the same un-settled game - update its data but keep showing it
          const gameEndTime = new Date(currentGame.end_time).getTime();
          const now = Date.now();
          const windowEndTime = gameEndTime + 10000; // 10 seconds from game end
          const timeRemaining = Math.max(0, windowEndTime - now);
          
          setDisplayedGame(currentGame); // Update with latest data
          setSettlementWindowEndTime(windowEndTime);
          const remaining = Math.ceil(timeRemaining / 1000);
          setSettlementCountdown(Math.max(0, remaining));
        } else {
          // Backend no longer returns our un-settled game (might have been settled)
          // But wait - if it's settled, backend won't return it. Keep showing our displayed game
          // until we explicitly know it's settled
          // Calculate countdown for the displayed game
          const gameEndTime = new Date(displayedGame.end_time).getTime();
          const now = Date.now();
          const windowEndTime = gameEndTime + 10000;
          const timeRemaining = Math.max(0, windowEndTime - now);
          const remaining = Math.ceil(timeRemaining / 1000);
          setSettlementCountdown(Math.max(0, remaining));
          
          // Keep showing the un-settled game - don't switch to new game
          return;
        }
      } else if (currentGame?.status === 'completed' && currentGame?.settlement_status === 'not_settled') {
        // Backend returns an un-settled completed game - show it
        const gameEndTime = new Date(currentGame.end_time).getTime();
        const now = Date.now();
        const windowEndTime = gameEndTime + 10000; // 10 seconds from game end
        const timeRemaining = Math.max(0, windowEndTime - now);
        
        setDisplayedGame(currentGame);
        setSettlementWindowEndTime(windowEndTime);
        const remaining = Math.ceil(timeRemaining / 1000);
        setSettlementCountdown(Math.max(0, remaining));
        
      } else if (currentGame && (currentGame.status === 'active' || currentGame.status === 'pending')) {
        // Backend returns an active/pending game
        // Only show it if we're NOT displaying an un-settled game
        if (!isDisplayingUnsettled) {
          // No un-settled game to block - show the active/pending game
          setDisplayedGame(currentGame);
          setSettlementWindowEndTime(null);
          setSettlementCountdown(null);
          setSelectedCard(null);
        }
        // If we're displaying an un-settled game, we already returned above
        
      } else if (!currentGame) {
        // No game returned by backend
        // If we're displaying an un-settled game, keep showing it
        if (!isDisplayingUnsettled) {
          // No un-settled game to keep - clear everything
          setDisplayedGame(null);
          setSettlementWindowEndTime(null);
          setSettlementCountdown(null);
          setSelectedCard(null);
        }
        // Otherwise keep showing the un-settled game
      }
      
    } catch (err: any) {
      setError(err.response?.data?.message || err.message || 'Failed to load live settlement data');
    } finally {
      setIsLoading(false);
    }
  };

  // Poll for updates every 2 seconds (real-time updates)
  useEffect(() => {
    fetchData(); // Initial load
    
    // Poll every 2 seconds for live updates
    pollIntervalRef.current = setInterval(() => {
      fetchData();
    }, 2000);

    return () => {
      if (pollIntervalRef.current) {
        clearInterval(pollIntervalRef.current);
      }
    };
  }, []);

  // Handle settlement countdown timer
  useEffect(() => {
    const game = displayedGame;
    const isInWindow = game?.status === 'completed' && 
                       settlementWindowEndTime && 
                       Date.now() < settlementWindowEndTime &&
                       game.settlement_status === 'not_settled';
    
    if (isInWindow && settlementCountdown !== null && settlementCountdown > 0) {
      countdownIntervalRef.current = setInterval(() => {
        const now = Date.now();
        const timeRemaining = settlementWindowEndTime ? settlementWindowEndTime - now : 0;
        
        if (timeRemaining <= 0) {
          // Countdown finished - window expired
          setSettlementCountdown(0);
          setSelectedCard(null); // Clear selection
          // Auto-settle will happen on backend in auto mode
          // In manual mode, game stays until manually settled
          // Refresh to check if game was auto-settled or still pending
          setTimeout(() => {
            fetchData();
          }, 1000);
        } else {
          const remainingSeconds = Math.ceil(timeRemaining / 1000);
          setSettlementCountdown(remainingSeconds);
        }
      }, 1000);
    } else {
      if (countdownIntervalRef.current) {
        clearInterval(countdownIntervalRef.current);
      }
    }

    return () => {
      if (countdownIntervalRef.current) {
        clearInterval(countdownIntervalRef.current);
      }
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [displayedGame, settlementCountdown, settlementWindowEndTime]);

  // Format currency
  const formatCurrency = (amount: number) => {
    return `₹${Math.abs(amount).toLocaleString('en-IN', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}`;
  };

  // Format time
  const formatTime = (seconds: number) => {
    const mins = Math.floor(seconds / 60);
    const secs = seconds % 60;
    return `${mins}:${String(secs).padStart(2, '0')}`;
  };

  // Handle card selection - only allow after game ends and in manual mode
  const handleCardSelect = (cardNumber: number) => {
    const game = displayedGame || data?.current_game;
    const mode = data?.mode || 'manual';
    
    // Only allow selection if:
    // 1. Mode is manual
    // 2. Game is completed
    // 3. We're in settlement window (either from API or local timer)
    // 4. Not currently settling
    const inSettlementWindow = game?.status === 'completed' && 
                               (game?.is_in_settlement_window || (settlementWindowEndTime && Date.now() < settlementWindowEndTime));
    
    if (
      mode === 'manual' &&
      game?.status === 'completed' && 
      inSettlementWindow &&
      !isSettling
    ) {
      setSelectedCard(cardNumber);
    }
  };

  // Handle settlement confirmation
  const handleSettle = async () => {
    const game = displayedGame || data?.current_game;
    if (!selectedCard || !game) return;

    setIsSettling(true);
    setError(''); // Clear any previous errors
    try {
      await gameService.settleGame(game.game_id, {
        winning_card: selectedCard
      });
      
      // Clear settlement window state
      setDisplayedGame(null);
      setSettlementWindowEndTime(null);
      setSelectedCard(null);
      setShowConfirmDialog(false);
      
      // Refresh data immediately to show new game or "no game" message
      // The backend will no longer return the settled game
      setTimeout(() => {
        fetchData();
      }, 500);
      
    } catch (err: any) {
      const errorMessage = err.response?.data?.message || err.message || 'Failed to settle game';
      setError(errorMessage);
      console.error('Settlement error:', err);
    } finally {
      setIsSettling(false);
    }
  };

  // Get profit color
  const getProfitColor = (profit: number) => {
    if (profit > 0) return 'text-green-600';
    if (profit < 0) return 'text-red-600';
    return 'text-gray-600';
  };

  // Get profit background color
  const getProfitBgColor = (profit: number) => {
    if (profit > 0) return 'bg-green-50 border-green-200';
    if (profit < 0) return 'bg-red-50 border-red-200';
    return 'bg-gray-50 border-gray-200';
  };

  if (isLoading && !data) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-gray-900"></div>
      </div>
    );
  }

  if (error && !data) {
    return (
      <div className="text-center py-12">
        <AlertCircle className="h-12 w-12 text-red-500 mx-auto mb-4" />
        <p className="text-red-600">{error}</p>
        <Button onClick={fetchData} className="mt-4">
          <RefreshCw className="h-4 w-4 mr-2" />
          Retry
        </Button>
      </div>
    );
  }

  // Use displayedGame if available (for settlement window), otherwise use current_game
  const currentGame = displayedGame || data?.current_game;
  const mode = data?.mode || 'manual';
  const recentGames = data?.recent_games || [];
  
  // Check if we're in settlement window (either from API or local timer)
  const isInSettlementWindow = currentGame?.status === 'completed' && 
                                (currentGame?.is_in_settlement_window || 
                                 (settlementWindowEndTime && Date.now() < settlementWindowEndTime));

  return (
    <div className="space-y-6">
      {/* Header - Compact */}
      <div className="flex justify-between items-center">
        <div>
          <h1 className="text-2xl font-bold">Live Game Settlement</h1>
          <p className="text-sm text-gray-600 mt-0.5">Real-time game monitoring and settlement</p>
        </div>
        <div className="flex items-center gap-3">
          {/* Mode Badge */}
          <Badge variant={mode === 'auto' ? 'default' : 'secondary'} className="text-sm px-3 py-1">
            {mode === 'auto' ? '🔄 Auto' : '✋ Manual'} Mode
          </Badge>
          
          {/* Refresh Button */}
          <Button variant="outline" size="sm" onClick={fetchData} disabled={isLoading}>
            <RefreshCw className={`h-3 w-3 mr-1 ${isLoading ? 'animate-spin' : ''}`} />
            Refresh
          </Button>
        </div>
      </div>

      {/* Error Alert */}
      {error && (
        <div className="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded">
          {error}
        </div>
      )}

      <div className="grid grid-cols-1 lg:grid-cols-4 gap-6">
        {/* Previous Games History - Left Sidebar - Compact */}
        <div className="lg:col-span-1">
          <Card>
            <CardHeader className="pb-3">
              <CardTitle className="text-sm font-semibold">Previous Games</CardTitle>
              <CardDescription className="text-xs">Last 10 settled games</CardDescription>
            </CardHeader>
            <CardContent>
              <div className="space-y-2 max-h-[500px] overflow-y-auto">
                {recentGames.length === 0 ? (
                  <p className="text-sm text-gray-500 text-center py-4">No previous games</p>
                ) : (
                  recentGames.map((game) => (
                    <div
                      key={game.game_id}
                      className="flex items-center justify-between p-2 bg-gray-50 rounded hover:bg-gray-100 transition"
                    >
                      <div className="flex-1 min-w-0">
                        <div className="text-xs font-medium text-gray-900 truncate">
                          {game.game_id}
                        </div>
                        <div className="text-[10px] text-gray-500 mt-0.5">
                          {new Date(game.end_time).toLocaleTimeString()}
                        </div>
                      </div>
                      <div className="flex items-center gap-1 ml-2">
                        <Trophy className="h-3 w-3 text-yellow-500" />
                        <span className="text-sm font-bold text-blue-600">
                          {game.winning_card}
                        </span>
                      </div>
                    </div>
                  ))
                )}
              </div>
            </CardContent>
          </Card>
        </div>

        {/* Main Hero Area - Card Grid */}
        <div className="lg:col-span-3">
          {!currentGame ? (
            <Card>
              <CardContent className="py-12 text-center">
                <PlayCircle className="h-16 w-16 text-gray-400 mx-auto mb-4" />
                <h3 className="text-xl font-semibold text-gray-700 mb-2">Game is not started yet</h3>
                <p className="text-gray-500">Waiting for next game to start...</p>
              </CardContent>
            </Card>
          ) : (
            <>
              {/* Game Info Banner - Compact */}
              <Card className="mb-4">
                <CardContent className="pt-4 pb-4">
                  <div className="flex items-center justify-between flex-wrap gap-3">
                    <div className="flex items-center gap-4 flex-wrap">
                      <div>
                        <div className="text-xs text-gray-500">Game ID</div>
                        <div className="text-base font-bold">{currentGame.game_id}</div>
                      </div>
                      <div className="h-6 w-px bg-gray-300"></div>
                      <div>
                        <div className="text-xs text-gray-500">Status</div>
                        <Badge 
                          variant={
                            currentGame.status === 'active' ? 'default' : 
                            currentGame.status === 'completed' ? 'secondary' : 
                            'outline'
                          }
                          className="text-xs px-2 py-0.5"
                        >
                          {currentGame.status === 'active' && <PlayCircle className="h-3 w-3 mr-1" />}
                          {currentGame.status === 'completed' && <CheckCircle2 className="h-3 w-3 mr-1" />}
                          {currentGame.status.toUpperCase()}
                        </Badge>
                      </div>
                      <div className="h-6 w-px bg-gray-300"></div>
                      <div>
                        <div className="text-xs text-gray-500">Time Remaining</div>
                        <div className="text-base font-bold flex items-center gap-1">
                          <Clock className="h-4 w-4" />
                          {currentGame.status === 'active' || currentGame.status === 'pending' 
                            ? formatTime(currentGame.time_remaining_seconds)
                            : 'Game Ended'
                          }
                        </div>
                      </div>
                      <div className="h-6 w-px bg-gray-300"></div>
                      <div>
                        <div className="text-xs text-gray-500">Total Wagered</div>
                        <div className="text-base font-bold text-blue-600">
                          {formatCurrency(currentGame.total_wagered)}
                        </div>
                      </div>
                      <div>
                        <div className="text-xs text-gray-500">Total Slips</div>
                        <div className="text-base font-bold">{currentGame.total_slips}</div>
                      </div>
                    </div>
                  </div>

                  {/* Settlement Window Countdown - Only show after game ends and in manual mode */}
                  {currentGame.status === 'completed' && isInSettlementWindow && mode === 'manual' && (
                    <div className="mt-3 p-2 bg-yellow-50 border border-yellow-200 rounded">
                      <div className="flex items-center justify-between">
                        <div className="flex items-center gap-2">
                          <Timer className="h-4 w-4 text-yellow-600 animate-pulse" />
                          <div>
                            <div className="text-xs font-medium text-yellow-800">
                              Game Ended - Settlement Window Active ({settlementCountdown}s remaining)
                            </div>
                            <div className="text-[10px] text-yellow-600">
                              Select a winning card within {settlementCountdown}s or it will auto-generate
                            </div>
                          </div>
                        </div>
                        <div className="text-2xl font-bold text-yellow-600">
                          {settlementCountdown !== null ? `${settlementCountdown}s` : '0s'}
                        </div>
                      </div>
                    </div>
                  )}
                  
                  {/* Info message during active game */}
                  {currentGame.status === 'active' && (
                    <div className="mt-3 p-2 bg-blue-50 border border-blue-200 rounded">
                      <div className="flex items-center gap-2">
                        <PlayCircle className="h-4 w-4 text-blue-600" />
                        <div>
                          <div className="text-xs font-medium text-blue-800">
                            Game is Active
                          </div>
                          <div className="text-[10px] text-blue-600">
                            {mode === 'manual' 
                              ? 'Winner card can only be selected after the game ends (in manual mode)'
                              : 'Game will auto-settle after completion'
                            }
                          </div>
                        </div>
                      </div>
                    </div>
                  )}
                  
                  {/* Auto mode message for completed game */}
                  {currentGame.status === 'completed' && mode === 'auto' && (
                    <div className="mt-3 p-2 bg-purple-50 border border-purple-200 rounded">
                      <div className="flex items-center gap-2">
                        <RefreshCw className="h-4 w-4 text-purple-600" />
                        <div>
                          <div className="text-xs font-medium text-purple-800">
                            Auto Mode - Settlement in Progress
                          </div>
                          <div className="text-[10px] text-purple-600">
                            Winner card will be auto-generated within 10 seconds
                          </div>
                        </div>
                      </div>
                    </div>
                  )}
                </CardContent>
              </Card>

              {/* 12 Cards Grid - Compact Layout - 2 Rows of 6 Cards */}
              <div className="grid grid-cols-3 md:grid-cols-6 gap-2">
                {currentGame.card_stats.map((cardStat) => {
                  const isSelected = selectedCard === cardStat.card_number;
                  // Only allow selection in manual mode, after game ends, and in settlement window
                  const canSelect = mode === 'manual' &&
                                   currentGame.status === 'completed' && 
                                   isInSettlementWindow && 
                                   !isSettling;
                  
                  return (
                    <Card
                      key={cardStat.card_number}
                      className={`transition-all ${
                        canSelect ? 'cursor-pointer hover:ring-2 hover:ring-blue-400 hover:shadow-md' : 'cursor-not-allowed'
                      } ${
                        isSelected 
                          ? 'ring-2 ring-blue-500 border-blue-500 bg-blue-50' 
                          : getProfitBgColor(cardStat.profit)
                      } ${
                        !canSelect ? 'opacity-75' : ''
                      }`}
                      onClick={() => handleCardSelect(cardStat.card_number)}
                    >
                      <CardHeader className="pb-1 pt-3 px-3">
                        <div className="flex items-center justify-between">
                          <CardTitle className="text-base font-bold">
                            C{cardStat.card_number}
                          </CardTitle>
                          {isSelected && (
                            <Trophy className="h-4 w-4 text-blue-500" />
                          )}
                        </div>
                      </CardHeader>
                      <CardContent className="space-y-1 px-3 pb-3">
                        <div>
                          <div className="text-[10px] text-gray-500">Bet</div>
                          <div className="text-xs font-semibold text-gray-900 leading-tight">
                            {formatCurrency(cardStat.total_bet_amount)}
                          </div>
                        </div>
                        <div>
                          <div className="text-[10px] text-gray-500">Payout</div>
                          <div className="text-xs font-semibold text-blue-600 leading-tight">
                            {formatCurrency(cardStat.total_payout)}
                          </div>
                        </div>
                        <div className="pt-1 border-t border-gray-200">
                          <div className="text-[10px] text-gray-500">P/L</div>
                          <div className={`text-sm font-bold flex items-center gap-0.5 leading-tight ${getProfitColor(cardStat.profit)}`}>
                            {cardStat.profit >= 0 ? (
                              <TrendingUp className="h-3 w-3" />
                            ) : (
                              <TrendingDown className="h-3 w-3" />
                            )}
                            <span className="text-xs">{formatCurrency(cardStat.profit)}</span>
                          </div>
                          <div className="text-[10px] text-gray-400 mt-0.5">
                            {cardStat.profit_percentage.toFixed(1)}%
                          </div>
                        </div>
                        <div className="text-[10px] text-gray-400 pt-0.5">
                          {cardStat.bets_count} bet{cardStat.bets_count !== 1 ? 's' : ''}
                        </div>
                      </CardContent>
                    </Card>
                  );
                })}
              </div>

              {/* Settlement Button - Fixed at Bottom - Only show after game ends and in manual mode - Compact */}
              {mode === 'manual' && currentGame.status === 'completed' && isInSettlementWindow && selectedCard && (
                <div className="fixed bottom-0 left-0 right-0 lg:left-64 bg-white border-t border-gray-200 p-3 shadow-lg z-50">
                  <Card className="border-0 shadow-none">
                    <CardContent className="p-0">
                      <div className="flex items-center justify-between flex-wrap gap-3">
                        <div className="flex items-center gap-4 flex-wrap">
                          <div className="flex items-center gap-2">
                            <Trophy className="h-5 w-5 text-blue-600" />
                            <div>
                              <div className="text-xs text-gray-500">Selected Card</div>
                              <div className="text-xl font-bold">Card {selectedCard}</div>
                            </div>
                          </div>
                          <div className="h-8 w-px bg-gray-300"></div>
                          {currentGame.card_stats[selectedCard - 1] && (
                            <>
                              <div>
                                <div className="text-xs text-gray-500">Profit/Loss</div>
                                <div className={`text-lg font-bold ${getProfitColor(currentGame.card_stats[selectedCard - 1].profit)}`}>
                                  {formatCurrency(currentGame.card_stats[selectedCard - 1].profit)}
                                </div>
                              </div>
                              <div>
                                <div className="text-xs text-gray-500">Payout</div>
                                <div className="text-lg font-bold text-blue-600">
                                  {formatCurrency(currentGame.card_stats[selectedCard - 1].total_payout)}
                                </div>
                              </div>
                            </>
                          )}
                        </div>
                        <Button
                          onClick={() => setShowConfirmDialog(true)}
                          size="default"
                          disabled={isSettling}
                          className="min-w-[180px]"
                        >
                          {isSettling ? (
                            <>
                              <RefreshCw className="h-4 w-4 mr-2 animate-spin" />
                              Settling...
                            </>
                          ) : (
                            <>
                              <Trophy className="h-4 w-4 mr-2" />
                              Settle Card {selectedCard}
                            </>
                          )}
                        </Button>
                      </div>
                    </CardContent>
                  </Card>
                </div>
              )}
            </>
          )}
        </div>
      </div>

      {/* Confirmation Dialog */}
      {showConfirmDialog && selectedCard && currentGame && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
          <Card className="w-full max-w-md mx-4">
            <CardHeader>
              <CardTitle>Confirm Settlement</CardTitle>
              <CardDescription>
                Are you sure you want to settle game {currentGame.game_id} with Card {selectedCard}?
              </CardDescription>
            </CardHeader>
            <CardContent className="space-y-4">
              {currentGame.card_stats[selectedCard - 1] && (
                <div className="bg-gray-50 p-4 rounded-lg space-y-2">
                  <div className="flex justify-between">
                    <span className="text-gray-600">Total Wagered:</span>
                    <span className="font-bold">{formatCurrency(currentGame.total_wagered)}</span>
                  </div>
                  <div className="flex justify-between">
                    <span className="text-gray-600">Total Payout:</span>
                    <span className="font-bold text-blue-600">
                      {formatCurrency(currentGame.card_stats[selectedCard - 1].total_payout)}
                    </span>
                  </div>
                  <div className="flex justify-between border-t pt-2">
                    <span className="text-gray-600">Profit/Loss:</span>
                    <span className={`font-bold ${getProfitColor(currentGame.card_stats[selectedCard - 1].profit)}`}>
                      {formatCurrency(currentGame.card_stats[selectedCard - 1].profit)}
                    </span>
                  </div>
                </div>
              )}
              <div className="flex gap-3">
                <Button
                  variant="outline"
                  className="flex-1"
                  onClick={() => setShowConfirmDialog(false)}
                  disabled={isSettling}
                >
                  Cancel
                </Button>
                <Button
                  className="flex-1"
                  onClick={handleSettle}
                  disabled={isSettling}
                >
                  {isSettling ? (
                    <>
                      <RefreshCw className="h-4 w-4 mr-2 animate-spin" />
                      Settling...
                    </>
                  ) : (
                    'Confirm Settlement'
                  )}
                </Button>
              </div>
            </CardContent>
          </Card>
        </div>
      )}
    </div>
  );
};

export default LiveSettlementPage;
